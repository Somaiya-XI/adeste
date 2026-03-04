//
//  HabitLogicCore.swift
//  levelUp
//
//  This file holds the core data model and protocol for habit logic.  
//  engines on top of these types.
//

import Foundation
import Combine
import HealthKit

// MARK: - Types

/// progress information for one habit.
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

// MARK: - Storage Keys

private enum WakeUpStorageKeys {
    static let wakeUpTime      = "saved_wake_up_time"
    static let lastCheckInDate = "last_wake_up_checkin"
}

private enum ExerciseStorageKeys {
    static let stepGoal      = "saved_step_goal"
    static let lastCheckDate = "last_exercise_checkin_date"
    static let lastStepCount = "last_exercise_step_count"
}

// MARK: - Wake Up Manager

/// Engine for the "Wake Up" habit (30‑minute window).
final class AppHabitWakeUpManager: ObservableObject, HabitEngine {
    static let shared = AppHabitWakeUpManager()

    let habitName: String = "Wake Up"
    @Published var status: HabitStatusModel
    @Published var wakeUpTime: Date
    /// True when the last persisted check-in date is today.
    @Published var didCheckInToday: Bool = false
    /// 1800 seconds = 30 minutes.
    var wakeUpWindow: TimeInterval = 1800

    private init() {
        let defaults = UserDefaults.standard

        if let savedDate = defaults.object(forKey: WakeUpStorageKeys.wakeUpTime) as? Date {
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

        if let lastCheckIn = defaults.object(forKey: WakeUpStorageKeys.lastCheckInDate) as? Date {
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

    func checkIn() {
        let now = Date()
        let defaults = UserDefaults.standard
        defaults.set(now, forKey: WakeUpStorageKeys.lastCheckInDate)
        defaults.synchronize()
        didCheckInToday = true
        status.currentCount = 1
        status.lastUpdated = now
        print("✅ Habit System: Wake Up check-in saved at \(now)")
    }

    func updateTargetTime(to newTime: Date) {
        wakeUpTime = newTime
        let defaults = UserDefaults.standard
        defaults.set(newTime, forKey: WakeUpStorageKeys.wakeUpTime)
        defaults.synchronize()
        status.lastUpdated = Date()
        print("✅ Habit System: Wake Up time updated to \(newTime)")
    }

    func setTargetTime(newTime: Date) {
        updateTargetTime(to: newTime)
    }

    var isHabitQualified: Bool {
        let now = Date()
        let window = wakeUpTime ... wakeUpTime.addingTimeInterval(wakeUpWindow)
        let qualified = window.contains(now)
        print("✅ Habit System: Check status (Wake Up) → \(qualified)")
        return qualified
    }
}

// MARK: - Prayer Manager

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
        Task {
            try? await self.refreshStatus()
            print("✅ Habit System: Check status (Prayer) → \(self.status.currentCount)/\(Prayer.allCases.count)")
        }
        return status.currentCount >= Double(Prayer.allCases.count)
    }
}

// MARK: - Exercise Manager

/// Engine for the "Exercise" habit.
/// Qualified when today's HealthKit step count ≥ 80% of the user-defined goal.
final class AppHabitExerciseManager: ObservableObject, HabitEngine {
    static let shared = AppHabitExerciseManager()

    let habitName: String = "Exercise"
    @Published var status: HabitStatusModel

    /// The daily step goal the user chose (default 10,000).
    @Published var stepGoal: Double {
        didSet {
            UserDefaults.standard.set(stepGoal, forKey: ExerciseStorageKeys.stepGoal)
            status.goalCount = stepGoal
        }
    }

    /// 80% threshold for qualification.
    let qualificationThreshold: Double = 0.80

    private let healthStore = HKHealthStore()

    private init() {
        let defaults = UserDefaults.standard

        let savedGoal  = defaults.double(forKey: ExerciseStorageKeys.stepGoal)
        let goal       = savedGoal > 0 ? savedGoal : 10_000
        self.stepGoal  = goal

        // Restore last-known step count so the UI isn't empty on cold start.
        let savedSteps = defaults.double(forKey: ExerciseStorageKeys.lastStepCount)
        let savedDate  = defaults.object(forKey: ExerciseStorageKeys.lastCheckDate) as? Date
        let isToday    = savedDate.map { Calendar.current.isDateInToday($0) } ?? false

        self.status = HabitStatusModel(
            currentCount: isToday ? savedSteps : 0,
            goalCount: goal,
            lastUpdated: isToday ? savedDate : nil
        )
    }

    /// Request HealthKit read permission for step count.
    /// Call this once at app launch.
    func requestAuthorisation() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("⚠️ Habit System: HealthKit not available on this device.")
            return
        }
        let stepType = HKQuantityType(.stepCount)
        try await healthStore.requestAuthorization(toShare: [], read: [stepType])
        print("✅ Habit System: HealthKit authorisation granted for steps.")
    }

    /// Fetch today's step count from HealthKit and update status.
    func refreshSteps() async {
        let steps = await fetchTodaySteps()
        await MainActor.run {
            status.currentCount = steps
            status.goalCount    = stepGoal
            status.lastUpdated  = Date()
            let defaults = UserDefaults.standard
            defaults.set(steps, forKey: ExerciseStorageKeys.lastStepCount)
            defaults.set(Date(), forKey: ExerciseStorageKeys.lastCheckDate)
            print("✅ Habit System: Steps refreshed → \(Int(steps)) / \(Int(stepGoal))")
        }
    }

    private func fetchTodaySteps() async -> Double {
        await withCheckedContinuation { continuation in
            let stepType   = HKQuantityType(.stepCount)
            let startOfDay = Calendar.current.startOfDay(for: Date())
            let predicate  = HKQuery.predicateForSamples(
                withStart: startOfDay,
                end: Date(),
                options: .strictStartDate
            )
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                if let error {
                    print("⚠️ Habit System: HealthKit query error → \(error.localizedDescription)")
                    continuation.resume(returning: 0)
                    return
                }
                let steps = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                continuation.resume(returning: steps)
            }
            self.healthStore.execute(query)
        }
    }

    /// Update the step goal (exposed for settings UI).
    func updateStepGoal(_ newGoal: Double) {
        stepGoal = max(1, newGoal)
    }

    /// True when today's steps reach 80% of the goal.
    var isHabitQualified: Bool {
        Task { await self.refreshSteps() }
        let qualified = status.currentCount >= stepGoal * qualificationThreshold
        print("✅ Habit System: Check status (Exercise) → \(Int(status.currentCount))/\(Int(stepGoal)) qualified=\(qualified)")
        return qualified
    }
}

// MARK: - Athkar Manager

/// Engine for the "Athkar" habit.
/// Wraps AthkarManager and bridges it to HabitEngine.
/// Progress: 1/2 morning done, 2/2 both done.
/// Qualified: both morning and evening are completed.
final class AppHabitAthkarManager: ObservableObject, HabitEngine {
    static let shared = AppHabitAthkarManager()

    let habitName: String = "Athkar"
    @Published var status: HabitStatusModel

    private let coreManager: AthkarManager

    private init() {
        let timesProvider = LocationBasedPrayerTimesProvider(
            locationService: LocationService(),
            factory: PrayerTimesProviderFactory()
        )
        self.coreManager = AthkarManager(
            timesProvider: timesProvider,
            store: UserDefaultsAthkarStore()
        )
        self.status = HabitStatusModel(
            currentCount: 0,
            goalCount: 2,
            lastUpdated: nil
        )
    }

    /// Refresh progress from AthkarManager.
    func refreshStatus(now: Date = Date()) async throws {
        let progress = try await coreManager.progressForToday(now: now)
        await MainActor.run {
 
            status.lastUpdated  = now
            print("✅ Habit System: Athkar refreshed → \(Int(status.currentCount))/2")
        }
    }

    /// Returns the current period to show on the button (morning / evening / nil).
    func currentPeriod(now: Date = Date()) async throws -> AthkarPeriod? {
        try await coreManager.currentPeriod(now: now)
    }

    /// Check in for the given period. Call this when the user taps the button.
    func checkIn(period: AthkarPeriod, now: Date = Date()) async throws {
        try await coreManager.checkIn(period: period, now: now)
        try await refreshStatus(now: now)
    }

    /// True when both morning and evening are completed (2/2).
    var isHabitQualified: Bool {
        Task { try? await self.refreshStatus() }
        let qualified = status.currentCount >= 2
        print("✅ Habit System: Check status (Athkar) → \(Int(status.currentCount))/2 qualified=\(qualified)")
        return qualified
    }
}
