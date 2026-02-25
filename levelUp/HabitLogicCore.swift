//
//  HabitLogicCore.swift
//  levelUp
//
//  This file holds the core data model and protocol for habit logic.  
//  engines on top of these types.
//

import Foundation
import Combine

/// Core progress information for one habit.
struct HabitStatusModel {
    var currentCount: Double
    var goalCount: Double
    var lastUpdated: Date?
}

/// Shared contract for all habit logic engines.
protocol HabitEngine {
    var habitName: String { get }
    var status: HabitStatusModel { get set }
    var isHabitQualified: Bool { get }
}

private enum HabitStorageKeys {
    static let wakeUpTime = "saved_wake_up_time"
    static let lastCheckInDate = "last_wake_up_checkin"
}

// Wake Up Manager

/// Engine for the "Wake Up" habit (30‑minute).
final class AppHabitWakeUpManager: ObservableObject, HabitEngine {
    static let shared = AppHabitWakeUpManager()

    let habitName: String = "Wake Up"
    @Published var status: HabitStatusModel
    @Published var wakeUpTime: Date
    /// True when the last persisted check-in date is today
    @Published var didCheckInToday: Bool = false
    /// 1800 seconds = 30 minutes.
    var wakeUpWindow: TimeInterval = 1800

    private init() {
        let defaults = UserDefaults.standard

        if let savedDate = defaults.object(forKey: HabitStorageKeys.wakeUpTime) as? Date {
            self.wakeUpTime = savedDate
        } else {
            let now = Date()
            let calendar = Calendar.current
            self.wakeUpTime = calendar.date(
                bySettingHour: 6,
                minute: 0,
                second: 0,
                of: now
            ) ?? now
        }

        if let lastCheckIn = defaults.object(forKey: HabitStorageKeys.lastCheckInDate) as? Date {
            self.didCheckInToday = Calendar.current.isDateInToday(lastCheckIn)
        } else {
            self.didCheckInToday = false
        }

        self.status = HabitStatusModel(
            currentCount: 0,
            goalCount: 1,
            lastUpdated: nil
        )
    }

    /// Persist check-in so the checkmark stays green after app restart.
    func checkIn() {
        let now = Date()
        let defaults = UserDefaults.standard
        defaults.set(now, forKey: HabitStorageKeys.lastCheckInDate)
        defaults.synchronize()
        didCheckInToday = true
        status.currentCount = 1
        status.lastUpdated = now
        print("✅ Habit System: Wake Up check-in saved at \(now)")
    }

    /// Update and persist the target wake‑up time.
    func updateTargetTime(to newTime: Date) {
        wakeUpTime = newTime

        let defaults = UserDefaults.standard
        defaults.set(newTime, forKey: HabitStorageKeys.wakeUpTime)
        defaults.synchronize()

        status.lastUpdated = Date()
        print("✅ Habit System: Wake Up time updated to \(newTime)")
    }

    /// Backwards-compatible helper if older code still calls `setTargetTime`.
    func setTargetTime(newTime: Date) {
        updateTargetTime(to: newTime)
    }

    /// True when the current time is within 30 minutes of the target time.
    var isHabitQualified: Bool {
        let now = Date()
        let window = wakeUpTime ... wakeUpTime.addingTimeInterval(wakeUpWindow)
        let qualified = window.contains(now)
        print("✅ Habit System: Check status (Wake Up) → \(qualified)")
        return qualified
    }
}

// Prayer Manager

/// Engine for the daily prayer habit, backed by the core PrayerManager.
final class AppHabitPrayerManager: ObservableObject, HabitEngine {
    static let shared = AppHabitPrayerManager()

    let habitName: String = "Prayer"
    @Published var status: HabitStatusModel

    private let coreManager: PrayerManager

    private init() {
        let locationService = LocationService()
        self.coreManager = PrayerManager(locationService: locationService)

        self.status = HabitStatusModel(
            currentCount: 0,
            goalCount: Double(Prayer.allCases.count),
            lastUpdated: nil
        )
    }

    /// Refresh status from the underlying prayer system.
    func refreshStatus(now: Date = Date()) async throws {
        let checked = try await coreManager.checkedPrayersForToday(now: now)
        status.currentCount = Double(checked.count)
        status.lastUpdated = now
    }

    /// True only when all prayers are completed in their valid windows.
    var isHabitQualified: Bool {
        // Kick off a background refresh so our status stays in sync.
        Task {
            try? await self.refreshStatus()
            print("✅ Habit System: Check status (Prayer) → \(self.status.currentCount)/\(Prayer.allCases.count)")
        }
        return status.currentCount >= Double(Prayer.allCases.count)
    }
}
