//
//  AppStreakManager.swift
//  levelUp
//
//  Global streak tracking based on habit qualification.
//

import Foundation
import Combine

/// Global streak manager shared across the app.
final class AppStreakManager: ObservableObject {
    static let shared = AppStreakManager()

    @Published private(set) var streakCount: Int

    private var lastStreakDate: Date?

    private enum StorageKeys {
        static let streakCount = "app_streak_count"
        static let lastStreakDate = "app_last_streak_date"
    }

    private init() {
        let defaults = UserDefaults.standard
        streakCount = defaults.integer(forKey: StorageKeys.streakCount)
        lastStreakDate = defaults.object(forKey: StorageKeys.lastStreakDate) as? Date
    }

    /// Recalculate today's streak based on the user's current cycle habits.
    /// A day is "successful" if at least one habit is qualified.
    func refreshForToday(habits: [Habit], now: Date = Date()) {
        guard !habits.isEmpty else { return }

        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: now)

        /// If we've already recorded streak for today, do nothing.
        if let last = lastStreakDate, calendar.isDate(last, inSameDayAs: todayStart) {
            return
        }

        /// Check if any habit in the current cycle is qualified.
        let successfulToday = habits.contains { habit in
            switch habit.type {
            case .wakeUp:
                return AppHabitWakeUpManager.shared.isHabitQualified
            case .prayer:
                return AppHabitPrayerManager.shared.isHabitQualified
            case .water, .steps, .athkar:
                 return false
            }
        }

        guard successfulToday else {
            /// No successful habits today; keep current streak until a future success resets to 1.
            return
        }

        if let last = lastStreakDate {
            let yesterdayStart = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -1, to: now) ?? now)

            if calendar.isDate(last, inSameDayAs: yesterdayStart) {
                /// Consecutive successful day → increment streak.
                streakCount += 1
            } else {
                /// First successful day after a miss → reset to 1.
                streakCount = 1
            }
        } else {
            /// First ever successful day.
            streakCount = 1
        }

        /// Sync to user profile as the single source of truth for persisted streak.
        syncToUserManager()

        lastStreakDate = todayStart
        persist()
    }

    private func persist() {
        let defaults = UserDefaults.standard
        defaults.set(streakCount, forKey: StorageKeys.streakCount)
        defaults.set(lastStreakDate, forKey: StorageKeys.lastStreakDate)
        defaults.synchronize()
    }

    /// Mirror the current streakCount into UserManager's current user and save.
    private func syncToUserManager() {
        let manager = UserManager.shared
        guard manager.currentUser != nil else { return }
        manager.currentUser?.streak = streakCount
        manager.saveUser()
    }
}

