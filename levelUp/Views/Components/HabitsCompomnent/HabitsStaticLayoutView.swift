////
////  HabitsStaticLayoutView.swift
////  HomePageUI
////
////  Created by Jory on 21/08/1447 AH.
////
//
//import SwiftUI
//

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
                habitView(habits[0], layoutType: .large)  // ← Large for single card
                    .frame(height: 320)

            case 2:
                VStack(spacing: 16) {
                    habitView(habits[0], layoutType: .small)  // ← Small for top
                        .frame(height: 120)
                    habitView(habits[1], layoutType: .small)  // ← Small for bottom
                        .frame(height: 120)
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
                    habitView(nonWaterHabits[0], layoutType: .small)  // ← Small
                        .frame(width: 168, height: 128)  // ← Match AdaptiveHabitCard size
                    habitView(nonWaterHabits[1], layoutType: .small)  // ← Small
                        .frame(width: 168, height: 128)
                }
                // Bottom: Water rectangle
                habitView(water, layoutType: .wide)  // ← Wide for bottom
                    .frame(height: 117.5)  // ← Match AdaptiveHabitCard size
            }
        } else {
            // All 3 are non-water habits
            VStack(spacing: 16) {
                // Top: 2 squares
                HStack(spacing: 16) {
                    habitView(habits[0], layoutType: .small)  // ← Small
                        .frame(width: 168, height: 128)
                    habitView(habits[1], layoutType: .small)  // ← Small
                        .frame(width: 168, height: 128)
                }
                // Bottom: rectangle
                habitView(habits[2], layoutType: .wide)  // ← Wide for bottom
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
            WaterHabitCardView(habit: habit, layoutType: layoutType)  // ← Pass layoutType

        case .steps:
            StepsHabitCardView(habit: habit, layoutType: layoutType)  // ← Pass layoutType

        case .wakeUp:
            WakeUpHabitCardView(habit: habit, layoutType: layoutType)  // ← Pass layoutType

        case .prayer:
            PrayerHabitCardView(habit: habit, layoutType: layoutType)  // ✅ Should already be there

        case .athkar:
            AthkarHabitCardView(
                         habit: habit,
                         layoutType: layoutType,
                         athkarManager: athkarManager
                     )        }
    }
}

#Preview("Habits – 3 items") {
    let prayerManager = PrayerManager(
        timesProvider: AdhanPrayerTimesProvider(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        store: UserDefaultsPrayerStore()
    )
    
    let athkarManager = AthkarManager(  // ← Variable name is lowercase
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
        prayerManager: prayerManager,  // ← lowercase
        athkarManager: athkarManager   // ← lowercase (not AthkarManager)
    )
    .padding()
}

