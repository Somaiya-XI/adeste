
//
//  HabitsStaticLayoutView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI

struct HabitsStaticLayoutView: View {
    let habits: [Habit]
    let prayerManager: PrayerManager
    let athkarManager: AthkarManager
    var body: some View {
        VStack(spacing: 16) {
            switch habits.count {
                // Single habit
            case 1:
                habitView(habits[0], layoutType: .large)
                    .frame(height: 243)
                
            case 2:
                VStack(spacing: 16) {
                    habitView(habits[0], layoutType: .wide)  // ← Changed from .small to .wide
                        .frame(height: 117.5)  // ← Match wide card height
                    habitView(habits[1], layoutType: .wide)  // ← Changed from .small to .wide
                        .frame(height: 117.5)  // ← Match wide card height
                }
                
                // Three habits - 2 squares + 1 rectangle
            case 3:
                threeHabitsLayout()
            default:
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    private func threeHabitsLayout() -> some View {
        if hasWaterHabit() {
            // Water MUST be rectangle (bottom position)
            let nonWaterHabits = habits.filter { $0.type != .water }
            let water = habits.first { $0.type == .water }!
            
            VStack(spacing: 16) {
                // Top: 2 squares side by side
                HStack(spacing: 16) {
                    habitView(nonWaterHabits[0], layoutType: .small)
                        .frame(width: 168, height: 128)
                    habitView(nonWaterHabits[1], layoutType: .small)
                        .frame(width: 168, height: 128)
                }
                // Bottom: Water rectangle
                habitView(water, layoutType: .wide)  // ← Wide for bottom
                    .frame(height: 117.5)  
            }
        } else {
            // All 3 are non-water habits
            VStack(spacing: 16) {
                // Top: 2 squares
                HStack(spacing: 16) {
                    habitView(habits[0], layoutType: .small)
                        .frame(width: 168, height: 128)
                    habitView(habits[1], layoutType: .small)
                        .frame(width: 168, height: 128)
                }
                // Bottom: rectangle
                habitView(habits[2], layoutType: .wide)
                    .frame(height: 117.5)
            }
        }
    }
    
    // Helper: Check if water habit exists
    private func hasWaterHabit() -> Bool {
        habits.contains { $0.type == .water }
    }
    
    @ViewBuilder
    private func habitView(_ habit: Habit, layoutType: HabitLayoutType) -> some View {
        switch habit.type {
        case .water:
            WaterHabitCardView(habit: habit, layoutType: layoutType)
            
        case .steps:
            StepsHabitCardView(habit: habit, layoutType: layoutType)
            
        case .wakeUp:
            WakeUpHabitCardView(habit: habit, layoutType: layoutType)
            
        case .prayer:
            PrayerHabitCardView(habit: habit, layoutType: layoutType)
            
            
            
        case .athkar:
            AthkarHabitCardView(
                habit: habit,
                layoutType: layoutType,
                athkarManager: athkarManager
            )        }
    }
}
#Preview("Habits – 2 items (Wide Layout)") {
    let prayerManager = PrayerManager(
        timesProvider: AdhanPrayerTimesProvider(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        store: UserDefaultsPrayerStore()
    )
    
    let athkarManager = AthkarManager(
        timesProvider: AdhanPrayerTimesProvider(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        store: UserDefaultsAthkarStore()
    )
    
    HabitsStaticLayoutView(
        habits: [
            Habit(title: "Prayer", type: .prayer),
            Habit(title: "Water", type: .water)
        ],
        prayerManager: prayerManager,
        athkarManager: athkarManager
    )
    .padding()
}

#Preview("Habits – 3 items") {
    let prayerManager = PrayerManager(
        timesProvider: AdhanPrayerTimesProvider(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        store: UserDefaultsPrayerStore()
    )
    
    let athkarManager = AthkarManager(
        timesProvider: AdhanPrayerTimesProvider(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        store: UserDefaultsAthkarStore()
    )
    
    HabitsStaticLayoutView(
        habits: [
            Habit(title: "Prayer", type: .prayer),
            Habit(title: "Steps", type: .steps),
            Habit(title: "Water", type: .water)
        ],
        prayerManager: prayerManager,
        athkarManager: athkarManager
    )
    .padding()
}
