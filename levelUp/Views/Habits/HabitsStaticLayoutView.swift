//
//  HabitsStaticLayoutView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI

enum HabitsLayoutState {
    case one
    case two
    case three
}
struct HabitsStaticLayoutView: View {
    let habits: [Habit]
    var body: some View {
        VStack(spacing: 16) {

            switch habits.count {

            case 1:
                habitView(habits[0])
                                   .frame(height: 240)

            case 2:
                VStack(spacing: 16) {
                                  habitView(habits[0])
                                      .frame(height: 100)
                                  habitView(habits[1])
                                      .frame(height: 100)
                              }


            case 3:
                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        habitView(habits[0])
                            .frame(height: 120)

                        habitView(habits[1])
                            .frame(height: 120)
                    }

                    habitView(habits[2])
                        .frame(height: 120)
                }

            default:
                           EmptyView()
            }
        }
    }
    @ViewBuilder
        private func habitView(_ habit: Habit) -> some View {
            switch habit.type {
                
            case .water:
                WaterHabitCardView(habit: habit)

                
            case .steps:
                HabitCardView(title: habit.title, subtitle: "\(habit.stepsCount) steps", type: .steps)
                
            case .wakeUp:
                  
                    WakeUpHabitCardView(habit: habit)
                       
                   
            }
        }
    }


#Preview {
    HabitsStaticLayoutView(habits: PreviewData.pageOne)
        .padding()
}



