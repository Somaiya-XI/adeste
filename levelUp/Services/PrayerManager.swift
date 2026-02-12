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

    /// Timezone for the location, approximated from longitude (1 hour per 15°).
    /// Adhan expects the calendar day and times in the location's local timezone;
    /// using the device timezone when the device is elsewhere causes hours-off errors.
    private var locationTimeZone: TimeZone {
        let secondsFromGMT = Int(round(longitude / 15.0) * 3600)
        return TimeZone(secondsFromGMT: secondsFromGMT) ?? .current
    }

    /// Calendar for the location (Gregorian, location timezone).
    /// Used so "today" and date components are the correct calendar day at the location.
    private var locationCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = locationTimeZone
        return cal
    }

    func prayerTimes(for dayStart: Date) async throws -> PrayerTimesDay {
        // "Today" at the location (so we request the correct calendar day for prayer times).
        let calendar = locationCalendar
        let dayStartInLocation = calendar.startOfDay(for: dayStart)
        var components = calendar.dateComponents([.year, .month, .day], from: dayStartInLocation)
        // Adhan uses Calendar.gregorianUTC internally, so pass UTC so the library gets midnight
        // on this calendar day in UTC and computes correctly. Times returned are in UTC.
        components.timeZone = TimeZone(identifier: "UTC")!

        let coordinates = Coordinates(latitude: latitude, longitude: longitude)

        var params = calculationMethod.params
        params.madhab = madhab

        #if DEBUG
        let formatter = DateFormatter()
        formatter.timeZone = locationTimeZone
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        print("[AdhanPrayerTimesProvider] coordinates: lat=\(latitude), lon=\(longitude) (latitude first, longitude second)")
        print("[AdhanPrayerTimesProvider] locationTimeZone: UTC\(locationTimeZone.secondsFromGMT() >= 0 ? "+" : "")\(locationTimeZone.secondsFromGMT() / 3600)h (\(locationTimeZone.identifier))")
        print("[AdhanPrayerTimesProvider] deviceTimeZone: \(TimeZone.current.identifier) (secondsFromGMT: \(TimeZone.current.secondsFromGMT()))")
        print("[AdhanPrayerTimesProvider] date for calculation: year=\(components.year!), month=\(components.month!), day=\(components.day!)")
        #endif

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

        // Adhan returns Date values as correct UTC instants (e.g. 02:58 UTC = 05:58 Moscow).
        // Use them as-is; display must use the location's timezone when formatting.
        #if DEBUG
        formatter.dateFormat = "HH:mm"
        print("[AdhanPrayerTimesProvider] raw times (UTC instants, shown in location TZ): fajr=\(formatter.string(from: prayerTimes.fajr)) sunrise=\(formatter.string(from: prayerTimes.sunrise)) dhuhr=\(formatter.string(from: prayerTimes.dhuhr)) asr=\(formatter.string(from: prayerTimes.asr)) maghrib=\(formatter.string(from: prayerTimes.maghrib)) isha=\(formatter.string(from: prayerTimes.isha)) middleOfNight=\(formatter.string(from: sunnahTimes.middleOfTheNight))")
        #endif

        return PrayerTimesDay(
            dayStart: dayStartInLocation,
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

// MARK: - Prayer times debugging checklist
//
// What likely caused wrong times (hours off):
// - Using Calendar.current (device timezone) for the date passed to Adhan. Prayer times
//   must be computed for the calendar day and in the timezone of the LOCATION (lat/lon),
//   not the device. If the device is in a different timezone, you get the wrong day and/or
//   wrong local time conversion.
// - Not setting DateComponents.timeZone to the location timezone so the library can
//   output correct Date values.
//
// Testing checklist:
// - Simulator: Debug → Simulate Location → choose a city (e.g. Riyadh, Mecca, London).
//   Check console for [AdhanPrayerTimesProvider] logs: coordinates, locationTimeZone,
//   deviceTimeZone, date for calculation, raw times. Compare raw times with a known
//   source (e.g. IslamicFinder, Muslim Pro) for that city and date.
// - Real device: Ensure device timezone matches location (or accept that we use
//   longitude-based timezone approximation). Verify coordinates from debug log;
//   compare prayer times with another app or website for the same location and date.
// - If still wrong: confirm lat/lon order (latitude first, longitude second);
//   try a known location (e.g. Mecca: 21.4225, 39.8262) and compare.

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
        let checked = try await checkedPrayersForToday(now: now)
        return checked.count == Prayer.allCases.count
    }

    /// Returns the set of prayers that have a valid check-in today (within their window).
    /// Used by the ViewModel to show which prayers are already checked.
    func checkedPrayersForToday(now: Date = Date()) async throws -> Set<Prayer> {
        let dayStart = todayStart(now)
        let windows = try await windowsForToday(now: now)
        let checkIns = try store.load(for: dayStart)

        return Set(
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
    }

    /// Returns today's prayer windows (for UI display and canCheck derivation).
    func todayWindows(now: Date = Date()) async throws -> [PrayerWindow] {
        try await windowsForToday(now: now)
    }

    // MARK: - Current / Next Prayer Helpers

    /// Returns the prayer whose window currently contains `now`.
    ///
    /// - Uses the same windows that validate check-ins:
    ///   Fajr → Sunrise, Dhuhr → Asr, Asr → Maghrib, Maghrib → Isha, Isha → Middle of the Night.
    /// - After `middleOfTheNight` and before Fajr, this returns `nil` (no current prayer).
    func currentPrayer(now: Date = Date()) async throws -> Prayer? {
        let windows = try await windowsForToday(now: now)

        // Find the first window whose [start, end) range contains `now`.
        return windows.first(where: { window in
            now >= window.start && now < window.end
        })?.prayer
    }

    /// Returns the next prayer relative to `now`.
    ///
    /// - If `now` is inside a prayer window, this returns the *next* prayer after the current one.
    ///   - Example: if currently in Dhuhr window, returns Asr.
    ///   - Example: if currently in Isha window (Isha → Middle of the Night), returns Fajr.
    /// - If `now` is not inside any window:
    ///   - If it's before the first window start, returns the first upcoming prayer (usually Fajr).
    ///   - If it's after the last window end (i.e., after Middle of the Night), returns Fajr.
    func nextPrayer(now: Date = Date()) async throws -> Prayer {
        let windows = try await windowsForToday(now: now)

        // Ensure windows are ordered by start time (PrayerWindowService already does this,
        // but we sort defensively in case the implementation changes).
        let ordered = windows.sorted { $0.start < $1.start }

        // Try to find the current window that contains `now`.
        if let currentIndex = ordered.firstIndex(where: { window in
            now >= window.start && now < window.end
        }) {
            let nextIndex = ordered.index(after: currentIndex)

            // If there is a later prayer window today, return its prayer.
            if nextIndex < ordered.count {
                return ordered[nextIndex].prayer
            } else {
                // We are in the last window of the day (Isha → Middle of the Night).
                // "Next" prayer is Fajr of the next day.
                return .fjr
            }
        }

        // Not in any window:
        // - If before the first window, return the first upcoming prayer today.
        if let upcoming = ordered.first(where: { now < $0.start }) {
            return upcoming.prayer
        }

        // - If after the last window end (after Middle of the Night), treat next prayer as Fajr.
        return .fjr
    }
}

// MARK: - Convenience Initialization with Location

extension PrayerManager {

    /// Convenience initializer that wires the manager to use the user's
    /// current location (via `LocationService`) for computing prayer times.
    ///
    /// Example usage from a ViewModel (pseudo-code):
    ///
    /// ```swift
    /// let locationService = LocationService()
    /// let prayerManager = PrayerManager(locationService: locationService)
    ///
    /// Task {
    ///     await locationService.requestAuthorizationIfNeeded()
    ///     let completed = try await prayerManager.progressForToday()
    /// }
    /// ```
    init(
        locationService: LocationService,
        providerFactory: PrayerTimesProviderFactory = PrayerTimesProviderFactory(),
        store: UserDefaultsPrayerStore = UserDefaultsPrayerStore()
    ) {
        let provider = LocationBasedPrayerTimesProvider(
            locationService: locationService,
            factory: providerFactory
        )
        self.init(timesProvider: provider, store: store)
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
