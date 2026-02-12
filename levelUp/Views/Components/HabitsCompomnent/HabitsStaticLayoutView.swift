//
//  HabitsStaticLayoutView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI

struct HabitsStaticLayoutView: View {
    let habits: [Habit]
    var body: some View {
        VStack(spacing: 16) {

            switch habits.count {
//single habit
            case 1:
                habitView(habits[0])
                                   .frame(height: 320)

            case 2:
                VStack(spacing: 16) {
                                  habitView(habits[0])
                                      .frame(height: 120)
                                  habitView(habits[1])
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
                       habitView(nonWaterHabits[0])
                           .frame(width: 168, height: 146)
                       habitView(nonWaterHabits[1])
                           .frame(width: 168, height: 146)
                   }
                   // Bottom: Water rectangle
                   habitView(water)
                       .frame(height: 138)
               }
           } else {
               // All 3 are non-water habits
               VStack(spacing: 16) {
                   // Top: 2 squares
                   HStack(spacing: 16) {
                       habitView(habits[0])
                           .frame(width: 168, height: 132)
                       habitView(habits[1])
                           .frame(width: 168, height: 132)
                   }
                   // Bottom: rectangle
                   habitView(habits[2])
                       .frame(height: 138)
               }
           }
       }
    // Helper: Check if water habit exists
       private func hasWaterHabit() -> Bool {
           habits.contains { $0.type == .water }
       }
       
    

    @ViewBuilder
    private func habitView(_ habit: Habit) -> some View {
        switch habit.type {

        case .water:
            WaterHabitCardView(habit: habit)

        case .steps:
            StepsHabitCardView(habit: habit)

        case .wakeUp:
            WakeUpHabitCardView(habit: habit)

        case .prayer:
            PrayerHabitCardView(habit: habit)

        case .athkar:
            AthkarHabitCardView(habit: habit)
        }
    }

    }
//
//#Preview("Habits – 1 item") {
//    HabitsStaticLayoutView(
//        habits: [
//            Habit(title: "Water", type: .water)
//        ]
//    )
//    .padding()
//}
//
//#Preview("Habits – 2 items") {
//    HabitsStaticLayoutView(
//        habits: [
//            Habit(title: "Steps", type: .steps),
//            Habit(title: "Wake Up", type: .wakeUp)
//        ]
//    )
//    .padding()
//}
#Preview("Habits – 3 items") {
    HabitsStaticLayoutView(
        habits: [
            Habit(title: "Water", type: .water),
            Habit(title: "Steps", type: .steps),
            Habit(title: "Athkar صباح", type: .athkar)
        ]
    )
    .padding()
}





