//
//  AppStreakManager.swift
//  levelUp
//
//  Global streak tracking based on habit qualification.
//

import Foundation
import Combine
import UIKit

/// Global streak manager shared across the app.
final class AppStreakManager: ObservableObject {
    static let shared = AppStreakManager()

    @Published private(set) var streakCount: Int
    @Published var isTodaySuccessful: Bool = false

    private var lastStreakDate: Date?
    private var isInitialLoad: Bool = true

    private enum StorageKeys {
        static let streakCount = "app_streak_count"
        static let lastStreakDate = "app_last_streak_date"
    }

    private init() {
        let defaults = UserDefaults.standard
        streakCount = defaults.integer(forKey: StorageKeys.streakCount)
        lastStreakDate = defaults.object(forKey: StorageKeys.lastStreakDate) as? Date
        resetIfExpired(now: Date())
    }

    /// Recalculate today's streak based on the user's current cycle habits.
    /// A day is "successful" if at least one habit is qualified.
    func refreshForToday(habits: [Habit], now: Date = Date()) {
        guard !habits.isEmpty else { return }

        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: now)

        resetIfExpired(now: now)

        /// Check if any habit in the current cycle is qualified.
        let successfulToday = habits.contains { habit in
            switch habit.type {
            case .wakeUp:
                return AppHabitWakeUpManager.shared.isHabitQualified
            case .prayer:
                return AppHabitPrayerManager.shared.isHabitQualified
            case .water:
                return AppHabitWaterManager.shared.isHabitQualified
            case .steps:
                return AppHabitExerciseManager.shared.isHabitQualified
            case .athkar:
                return AppHabitAthkarManager.shared.isHabitQualified
            }
        }

        isTodaySuccessful = successfulToday

        // Require at least one manual interaction today (explicit user action),
        let calendarToday = Calendar.current
        let today = calendarToday.startOfDay(for: now)
        let wakeUpCheckedIn = AppHabitWakeUpManager.shared.didCheckInToday
        let waterProgress   = AppHabitWaterManager.shared.status.currentCount > 0
        let prayerProgress  = AppHabitPrayerManager.shared.status.currentCount > 0
        let athkarProgress  = AppHabitAthkarManager.shared.status.currentCount > 0

        let exerciseToday: Bool = {
            let exerciseStatus = AppHabitExerciseManager.shared.status
            guard let last = exerciseStatus.lastUpdated else { return false }
            return calendarToday.isDate(last, inSameDayAs: today) && exerciseStatus.currentCount > 0
        }()

        let hasManualInteractionToday =
            wakeUpCheckedIn || waterProgress || prayerProgress || athkarProgress || exerciseToday

        /// If we've already recorded streak for today, do nothing.
        if let last = lastStreakDate, calendar.isDate(last, inSameDayAs: todayStart) {
            return
        }

        guard successfulToday && hasManualInteractionToday else {
            /// No successful habits today; keep current streak until a future success resets to 1.
            return
        }

        var streakWasUpdated = false

        /// Successful day and we haven't updated today yet → increment streak once.
        streakCount += 1
        streakWasUpdated = true

        /// Sync to user profile as the single source of truth for persisted streak.
        syncToUserManager()

        lastStreakDate = todayStart
        persist()

        if streakWasUpdated && !isInitialLoad {
            let count = streakCount
            let dayString = count == 1 ? "Day" : "Days"
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 sec so "Habit Completed!" shows first
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                AppToastCenter.shared.show(message: "Streak: \(count) \(dayString)!")
            }
        }

        /// After the first evaluation, allow haptics/toasts for subsequent days.
        isInitialLoad = false
    }

    private func persist() {
        let defaults = UserDefaults.standard
        defaults.set(streakCount, forKey: StorageKeys.streakCount)
        defaults.set(lastStreakDate, forKey: StorageKeys.lastStreakDate)
        defaults.synchronize()
    }

    /// Reset streak if it has expired (user missed at least one full day).
    private func resetIfExpired(now: Date) {
        guard let last = lastStreakDate else { return }
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: now)
        let lastStart = calendar.startOfDay(for: last)

        guard let yesterdayStart = calendar.date(byAdding: .day, value: -1, to: todayStart) else { return }

        if lastStart < yesterdayStart {
            streakCount = 0
        }
    }

    /// Mirror the current streakCount into UserManager's current user and save.
    private func syncToUserManager() {
        let manager = UserManager.shared
        guard manager.currentUser != nil else { return }
        manager.currentUser?.streak = streakCount
        manager.saveUser()
    }
}

