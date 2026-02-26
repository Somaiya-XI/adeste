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

/// Keys for persistent storage
private enum HabitStorageKeys {
    static let wakeUpTime = "saved_wake_up_time"
    static let lastCheckInDate = "last_wake_up_checkin"
}

// Wake Up Manager
/// Engine for the "Wake Up" habit.
final class AppHabitWakeUpManager: ObservableObject, HabitEngine {
    static let shared = AppHabitWakeUpManager()

    let habitName: String = "Wake Up"
    @Published var status: HabitStatusModel
    @Published var wakeUpTime: Date
    @Published var didCheckInToday: Bool = false
    var wakeUpWindow: TimeInterval = 1800 // 30 minutes

    private init() {
            let defaults = UserDefaults.standard

            let savedTime = defaults.object(forKey: HabitStorageKeys.wakeUpTime) as? Date
            let initialWakeUpTime = savedTime ?? Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date()) ?? Date()
            self.wakeUpTime = initialWakeUpTime

            let isChecked: Bool
            if let lastCheckIn = defaults.object(forKey: HabitStorageKeys.lastCheckInDate) as? Date {
                isChecked = Calendar.current.isDateInToday(lastCheckIn)
            } else {
                isChecked = false
            }
            
            self.didCheckInToday = isChecked
            self.status = HabitStatusModel(
                currentCount: isChecked ? 1 : 0,
                goalCount: 1,
                lastUpdated: nil
            )
        }

    func checkIn() {
        let now = Date()
        let defaults = UserDefaults.standard
        defaults.set(now, forKey: HabitStorageKeys.lastCheckInDate)
        defaults.synchronize()
        
        didCheckInToday = true
        status.currentCount = 1
        status.lastUpdated = now
        print("✅ Habit System: Wake Up check-in saved and memory updated")
    }

    func updateTargetTime(to newTime: Date) {
        wakeUpTime = newTime
        UserDefaults.standard.set(newTime, forKey: HabitStorageKeys.wakeUpTime)
        UserDefaults.standard.synchronize()
        status.lastUpdated = Date()
    }

    /// This property ensures the character stays on the bar all day if check-in is done
    var isHabitQualified: Bool {
        return didCheckInToday
    }
}

// Prayer Manager
/// Engine for the daily prayer habit.
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
        
        Task {
            try? await self.refreshStatus()
        }
    }

    func refreshStatus(now: Date = Date()) async throws {
        let checked = try await coreManager.checkedPrayersForToday(now: now)
        await MainActor.run {
            self.status.currentCount = Double(checked.count)
            self.status.lastUpdated = now
            print("✅ Habit System: Prayers refreshed (\(checked.count)/5)")
        }
    }

    var isHabitQualified: Bool {
        // Any prayer completed will move the character forward
        return status.currentCount > 0
    }
}
