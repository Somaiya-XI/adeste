//
//  AppProgressManager.swift
//  adeste
//
//  Created by yumii on 26/02/2026.
//

import SwiftUI

@Observable
class AppProgressManager {
    static let shared = AppProgressManager()
    
    var completionPercentage: CGFloat = 0.0
    var completedCount: Int = 0
    var totalCount: Int = 0
    private var hasAnimatedThisSession: Bool = false

    func updateProgress(habits: [Habit]) {
        guard !habits.isEmpty else {
            completionPercentage = 0
            return
        }
        
        let completed = habits.filter { habit in
            switch habit.type {
            case .wakeUp:
                return AppHabitWakeUpManager.shared.isHabitQualified
            case .prayer:
                return AppHabitPrayerManager.shared.isHabitQualified
            case .water, .steps, .athkar:
                return false
            }
        }.count
        
        self.completedCount = completed
        self.totalCount = habits.count
        
        let newPercentage = CGFloat(completed) / CGFloat(habits.count)

      
        if !hasAnimatedThisSession && newPercentage == 0 {
            self.completionPercentage = 0
        } else {
            withAnimation(.spring()) {
                self.completionPercentage = newPercentage
            }
            if newPercentage > 0 {
                hasAnimatedThisSession = true
            }
        }
    }
}
