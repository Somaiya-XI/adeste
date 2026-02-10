//
//  WakeUpHabitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct WakeUpHabitCardView: View {
   
        var habit: Habit

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {

                Text("Wake up")
                    .font(.headline)

                Text(habit.wakeUpTime?.formatted(date: .omitted, time: .shortened) ?? "Not set")

                

                switch habit.wakeUpStatus {

                case .active:
                    Button("I'm awake") {
                        habit.checkInWakeUp()
                    }

                case .completed:
                    Text("proud!")

                case .missed:
                    Text("try again tomorrow")

                case .upcoming:
                    Text(" Not yet")

                case .notSet:
                    Text("Set your wake up time")
                }
            }
            .padding()
            .background(habit.type.color)
            .cornerRadius(20)
        }
    }



#Preview {
    WakeUpHabitCardView(habit: PreviewData.wakeUpHabit)
        .padding()
}
