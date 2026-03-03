
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
    @Binding var showWakeUpTimePopup: Bool
    @Binding var selectedWakeUpTime: Date

    var body: some View {
        VStack(spacing: 16) {
            switch habits.count {
            case 1:
                habitView(habits[0], layoutType: .large)
                    .frame(height: 243)
            case 2:
                VStack(spacing: 16) {
                    habitView(habits[0], layoutType: .wide)
                        .frame(height: 117.5)
                    habitView(habits[1], layoutType: .wide)
                        .frame(height: 117.5)
                }
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
            let nonWaterHabits = habits.filter { $0.type != .water }
            let water = habits.first { $0.type == .water }!
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    habitView(nonWaterHabits[0], layoutType: .small)
                        .frame(width: 168, height: 128)
                    habitView(nonWaterHabits[1], layoutType: .small)
                        .frame(width: 168, height: 128)
                }
                habitView(water, layoutType: .wide)
                    .frame(height: 117.5)
            }
        } else {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    habitView(habits[0], layoutType: .small)
                        .frame(width: 168, height: 128)
                    habitView(habits[1], layoutType: .small)
                        .frame(width: 168, height: 128)
                }
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
            WakeUpHabitCardView(
                habit: habit,
                layoutType: layoutType,
                showWakeUpTimePopup: $showWakeUpTimePopup,
                selectedWakeUpTime: $selectedWakeUpTime
            )
        case .prayer:
            PrayerHabitCardView(habit: habit, layoutType: layoutType)
        case .athkar:
            AthkarHabitCardView(
                habit: habit,
                layoutType: layoutType,
                athkarManager: athkarManager
            )
        }
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
        athkarManager: athkarManager,
        showWakeUpTimePopup: .constant(false),
        selectedWakeUpTime: .constant(Date())
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
        athkarManager: athkarManager,
        showWakeUpTimePopup: .constant(false),
        selectedWakeUpTime: .constant(Date())
    )
    .padding()
}
