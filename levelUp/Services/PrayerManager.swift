//
//  PrayerManager.swift
//  levelUp
//
//  Created by Dana AlGhadeer on 09/02/2026.
//
import Foundation
import SwiftData
import Adhan


//  1) Prayer window = start of prayer → end of that prayer time
//     - Fajr ends at Sunrise
//     - Dhuhr ends at Asr
//     - Asr ends at Maghrib
//     - Maghrib ends at Isha
//     - Isha ends at Middle of the Night (Islamic midnight)
//  2) User cannot check a prayer outside its window (throw error → UI shows popup)
//  3) Progress is binary: 100% (true) ONLY if all 5 prayers are checked in valid windows
//     Missing one prayer => 0% (false)

enum Prayer: String, CaseIterable, Codable, Hashable {
    case fjr = "Fajr"
    case dhr = "Dhuhr"
    case asr = "Asr"
    case mgb = "Magrib"
    case ish = "Isha"
}

struct PrayerCheckIn: Codable, Hashable {
    let prayer: Prayer
    let checkedAt: Date
}

//struct PrayerProgress {
//    let isPrayerProgressCompleted: Bool   // true = 100%, false = 0%
//}


struct PrayerTimesDay: Equatable {
  
    let dayStart: Date


    let times: [Prayer: Date] //Prayer start times

// Boundries for the prayer windows
    let sunrise: Date              // ends Fajr
    let middleOfTheNight: Date     // ends Isha
}

enum PrayerCheckInError: LocalizedError, Equatable {
    case outsideWindow(prayer: Prayer)
    case prayerTimesUnavailable

    var errorDescription: String? {
        switch self {
        case .outsideWindow(let prayer):
            return "You can’t check \(prayer.rawValue) outside its prayer time."
        case .prayerTimesUnavailable:
            return "Prayer times couldn’t be loaded. Please try again."
        }
    }
}


protocol PrayerTimesProviding {
    func prayerTimes(for dayStart: Date) async throws -> PrayerTimesDay
}

struct AdhanPrayerTimesProvider: PrayerTimesProviding {
    let latitude: Double
    let longitude: Double


    var calculationMethod: CalculationMethod = .muslimWorldLeague
    var madhab: Madhab = .shafi

    func prayerTimes(for dayStart: Date) async throws -> PrayerTimesDay {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: dayStart)

        let coordinates = Coordinates(latitude: latitude, longitude: longitude)

        var params = calculationMethod.params
        params.madhab = madhab

        guard let prayerTimes = PrayerTimes(
            coordinates: coordinates,
            date: components,
            calculationParameters: params
        ) else {
            throw PrayerCheckInError.prayerTimesUnavailable
        }

        // Use SunnahTimes to compute middleOfTheNight (Islamic midnight)
        guard let sunnahTimes = SunnahTimes(from: prayerTimes) else {
            throw PrayerCheckInError.prayerTimesUnavailable
        }

        return PrayerTimesDay(
            dayStart: dayStart,
            times: [
                .fjr: prayerTimes.fajr,
                .dhr: prayerTimes.dhuhr,
                .asr: prayerTimes.asr,
                .mgb: prayerTimes.maghrib,
                .ish: prayerTimes.isha
            ],
            sunrise: prayerTimes.sunrise,
            middleOfTheNight: sunnahTimes.middleOfTheNight
        )
    }
}

struct PrayerWindow {
    let prayer: Prayer
    let start: Date
    let end: Date
}

struct PrayerWindowService {

    func buildWindows(today: PrayerTimesDay) -> [PrayerWindow] {
        // keep a fixed order for consistency
        let order: [Prayer] = [.fjr, .dhr, .asr, .mgb, .ish]
        var windows: [PrayerWindow] = []

        for prayer in order {
            guard let start = today.times[prayer] else { continue }

            let end: Date
            switch prayer {
            case .fjr:
                end = today.sunrise

            case .dhr:
                end = today.times[.asr] ?? start

            case .asr:
                end = today.times[.mgb] ?? start

            case .mgb:
                end = today.times[.ish] ?? start

            case .ish:
                end = today.middleOfTheNight
            }

            // Safety: if end is earlier than start, it crossed midnight → add 1 day
            let adjustedEnd = end < start
                ? Calendar.current.date(byAdding: .day, value: 1, to: end)!
                : end

            windows.append(PrayerWindow(prayer: prayer, start: start, end: adjustedEnd))
        }

        return windows
    }
}

extension PrayerWindowService {

    func isValidCheckIn(prayer: Prayer, at time: Date, windows: [PrayerWindow]) -> Bool {
        guard let window = windows.first(where: { $0.prayer == prayer }) else { return false }
        return time >= window.start && time < window.end
    }
}


final class UserDefaultsPrayerStore {
    private let defaults: UserDefaults
    init(defaults: UserDefaults = .standard) { self.defaults = defaults }

    private func key(for dayStart: Date) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return "prayer.checkins.\(f.string(from: dayStart))"
    }

    func load(for dayStart: Date) throws -> [PrayerCheckIn] {
        guard let data = defaults.data(forKey: key(for: dayStart)) else { return [] }
        return try JSONDecoder().decode([PrayerCheckIn].self, from: data)
    }

    func save(_ checkIns: [PrayerCheckIn], for dayStart: Date) throws {
        let data = try JSONEncoder().encode(checkIns)
        defaults.set(data, forKey: key(for: dayStart))
    }
}


struct PrayerManager {

    let timesProvider: PrayerTimesProviding
    let store: UserDefaultsPrayerStore
    let windowService = PrayerWindowService()

    private func todayStart(_ now: Date) -> Date {
        Calendar.current.startOfDay(for: now)
    }

    private func windowsForToday(now: Date) async throws -> [PrayerWindow] {
        let dayStart = todayStart(now)
        do {
            let today = try await timesProvider.prayerTimes(for: dayStart)
            return windowService.buildWindows(today: today)
        } catch {
            throw PrayerCheckInError.prayerTimesUnavailable
        }
    }

    /// Optional helper for UI (disable button)
    func canCheckIn(prayer: Prayer, now: Date = Date()) async throws -> Bool {
        let windows = try await windowsForToday(now: now)
        return windowService.isValidCheckIn(prayer: prayer, at: now, windows: windows)
    }

    // User taps “I prayed”
    func checkIn(prayer: Prayer, now: Date = Date()) async throws {
        let dayStart = todayStart(now)
        let windows = try await windowsForToday(now: now)

        guard windowService.isValidCheckIn(prayer: prayer, at: now, windows: windows) else {
            throw PrayerCheckInError.outsideWindow(prayer: prayer)
        }

        var checkIns = try store.load(for: dayStart)

        // One check-in per prayer per day
        checkIns.removeAll { $0.prayer == prayer }
        checkIns.append(PrayerCheckIn(prayer: prayer, checkedAt: now))

        try store.save(checkIns, for: dayStart)
    }

    /// STRICT rule:
    /// true = all 5 prayers checked in valid windows
    /// false = anything else
    func progressForToday(now: Date = Date()) async throws -> Bool {
        let dayStart = todayStart(now)
        let windows = try await windowsForToday(now: now)
        let checkIns = try store.load(for: dayStart)

        let validPrayers = Set(
            checkIns
                .filter {
                    windowService.isValidCheckIn(
                        prayer: $0.prayer,
                        at: $0.checkedAt,
                        windows: windows
                    )
                }
                .map(\.prayer)
        )

        return validPrayers.count == Prayer.allCases.count
    }
}


//struct PrayerManager {
//
//    let timesProvider: PrayerTimesProviding
//    let store: UserDefaultsPrayerStore
//    let windowService = PrayerWindowService()
//    var isPrayerProgressCompleted: Bool
//
//    private func todayStart(_ now: Date) -> Date {
//        Calendar.current.startOfDay(for: now)
//    }
//
//    private func windowsForToday(now: Date) async throws -> [PrayerWindow] {
//        let dayStart = todayStart(now)
//        do {
//            let today = try await timesProvider.prayerTimes(for: dayStart)
//            return windowService.buildWindows(today: today)
//        } catch {
//            // If Adhan/provider fails, convert to your error for UI
//            throw PrayerCheckInError.prayerTimesUnavailable
//        }
//    }
//
//    // Optional helper for UI (disable button)
//    func canCheckIn(prayer: Prayer, now: Date = Date()) async throws -> Bool {
//        let windows = try await windowsForToday(now: now)
//        return windowService.isValidCheckIn(prayer: prayer, at: now, windows: windows)
//    }
//
//    func checkIn(prayer: Prayer, now: Date = Date()) async throws {
//        let dayStart = todayStart(now)
//        let windows = try await windowsForToday(now: now)
//
//        // STRICT RULE: cannot check outside window
//        guard windowService.isValidCheckIn(prayer: prayer, at: now, windows: windows) else {
//            throw PrayerCheckInError.outsideWindow(prayer: prayer)
//        }
//
//        var checkIns = try store.load(for: dayStart)
//
//        // One check-in per prayer per day (latest wins)
//        checkIns.removeAll { $0.prayer == prayer }
//        checkIns.append(PrayerCheckIn(prayer: prayer, checkedAt: now))
//
//        try store.save(checkIns, for: dayStart)
//    }
//
//    // Progress is binary: 100% only if all 5 prayers are valid check-ins
//    mutating func progressForToday(now: Date = Date()) async throws  {
//        let dayStart = todayStart(now)
//        let windows = try await windowsForToday(now: now)
//        let checkIns = try store.load(for: dayStart)
//
//        let validPrayers = Set(
//            checkIns
//                .filter { windowService.isValidCheckIn(prayer: $0.prayer, at: $0.checkedAt, windows: windows) }
//                .map(\.prayer)
//        )
//
//        isPrayerProgressCompleted = (validPrayers.count == Prayer.allCases.count)
//    }
//    
//    func progressForToday(now: Date = Date()) async throws -> PrayerProgress {
//        let dayStart = todayStart(now)
//        let windows = try await windowsForToday(now: now)
//        let checkIns = try store.load(for: dayStart)
//
//        let validPrayers = Set(
//            checkIns
//                .filter { windowService.isValidCheckIn(prayer: $0.prayer, at: $0.checkedAt, windows: windows) }
//                .map(\.prayer)
//        )
//
//        return PrayerProgress(isCompleted: validPrayers.count == Prayer.allCases.count)
//    }
//}
