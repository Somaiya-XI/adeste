//
//  AthkarManager.swift
//  levelUp
//
//  Created by Dana AlGhadeer on 10/02/2026.
//
import Foundation
import SwiftData
import Adhan



enum AthkarPeriod: String, CaseIterable, Codable, Hashable {
    case morning
    case evening
}

struct AthkarCheckIn: Codable, Hashable {
    let period: AthkarPeriod
    let checkedAt: Date
}

struct AthkarWindow: Equatable {
    let period: AthkarPeriod
    let start: Date
    let end: Date
}

struct AthkarProgress {
    let isCompleted: Bool  // true if at least one (morning or evening) is checked validly
}

struct AthkarWindowService {

    func buildWindows(today: PrayerTimesDay, tomorrow: PrayerTimesDay?) -> [AthkarWindow] {
        guard
            let fajr = today.times[.fjr],
            let asr = today.times[.asr]
        else { return [] }

        // Morning: Fajr -> Asr
        let morning = AthkarWindow(period: .morning, start: fajr, end: asr)

        // Evening: Asr -> next day's Fajr
        let nextFajr = tomorrow?.times[.fjr]
        let fallback = fajr
        let rawEnd = nextFajr ?? fallback

        let adjustedEnd = rawEnd < asr
            ? Calendar.current.date(byAdding: .day, value: 1, to: rawEnd)!
            : rawEnd

        let evening = AthkarWindow(period: .evening, start: asr, end: adjustedEnd)

        return [morning, evening]
    }

    func currentPeriod(now: Date, windows: [AthkarWindow]) -> AthkarPeriod? {
        windows.first(where: { now >= $0.start && now < $0.end })?.period
    }

    func isValidCheckIn(period: AthkarPeriod, at time: Date, windows: [AthkarWindow]) -> Bool {
        guard let w = windows.first(where: { $0.period == period }) else { return false }
        return time >= w.start && time < w.end
    }
}

final class UserDefaultsAthkarStore {
    private let defaults: UserDefaults
    init(defaults: UserDefaults = .standard) { self.defaults = defaults }

    private func key(for dayStart: Date) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return "athkar.checkins.\(f.string(from: dayStart))"
    }

    func load(for dayStart: Date) throws -> [AthkarCheckIn] {
        guard let data = defaults.data(forKey: key(for: dayStart)) else { return [] }
        return try JSONDecoder().decode([AthkarCheckIn].self, from: data)
    }

    func save(_ checkIns: [AthkarCheckIn], for dayStart: Date) throws {
        let data = try JSONEncoder().encode(checkIns)
        defaults.set(data, forKey: key(for: dayStart))
    }
}

//Ui wil prevent wrong taps but this is just in case
enum AthkarCheckInError: LocalizedError, Equatable {
    case outsideWindow(period: AthkarPeriod)
    case prayerTimesUnavailable

    var errorDescription: String? {
        switch self {
        case .outsideWindow(let period):
            return "You can’t check \(period.rawValue) athkar outside its time window."
        case .prayerTimesUnavailable:
            return "Prayer times couldn’t be loaded. Please try again."
        }
    }
}


struct AthkarManager {

    let timesProvider: PrayerTimesProviding
    let store: UserDefaultsAthkarStore
    let windowService = AthkarWindowService()

    private func todayStart(_ now: Date) -> Date {
        Calendar.current.startOfDay(for: now)
    }

    private func windowsForToday(now: Date) async throws -> [AthkarWindow] {
        let cal = Calendar.current
        let todayStart = todayStart(now)
        let tomorrowStart = cal.date(byAdding: .day, value: 1, to: todayStart)!

        do {
            let today = try await timesProvider.prayerTimes(for: todayStart)
            let tomorrow = try await timesProvider.prayerTimes(for: tomorrowStart)
            return windowService.buildWindows(today: today, tomorrow: tomorrow)
        } catch {
            throw AthkarCheckInError.prayerTimesUnavailable
        }
    }

    // Optional: backend can tell UI what to show (morning/evening card)
    func currentPeriod(now: Date = Date()) async throws -> AthkarPeriod? {
        let windows = try await windowsForToday(now: now)
        return windowService.currentPeriod(now: now, windows: windows)
    }
// Check in for whatever period UI is showing
    func checkIn(period: AthkarPeriod, now: Date = Date()) async throws {
        let dayStart = todayStart(now)
        let windows = try await windowsForToday(now: now)

        guard windowService.isValidCheckIn(period: period, at: now, windows: windows) else {
            throw AthkarCheckInError.outsideWindow(period: period)
        }

        var checkIns = try store.load(for: dayStart)
        checkIns.removeAll { $0.period == period }   // one per period
        checkIns.append(.init(period: period, checkedAt: now))
        try store.save(checkIns, for: dayStart)
    }

    // Progress is TRUE if at least one of morning/evening was checked validly.
        func progressForToday(now: Date = Date()) async throws -> AthkarProgress {
            let dayStart = todayStart(now)
            let windows = try await windowsForToday(now: now)
            let checkIns = try store.load(for: dayStart)

            let validPeriods = Set(
                checkIns
                    .filter { windowService.isValidCheckIn(period: $0.period, at: $0.checkedAt, windows: windows) }
                    .map(\.period)
            )

            let completed = !validPeriods.isEmpty   // ✅ your rule
            return AthkarProgress(isCompleted: completed)
        }
}

