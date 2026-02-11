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
                        VStack(alignment: .leading, spacing: 8) {
                            VStack(alignment: .leading) {
                                
                                
                                HStack{
                                    Text("Wake up")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Button {
                                        habit.checkInWakeUp()
                                    } label: {
                                        Image(systemName: habit.didCheckIn ?  "checkmark.circle.fill" : "checkmark.circle")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                        
                                    }
                                }
                                Text(habit.wakeUpTime?.formatted(date: .omitted, time: .shortened) ?? "Not set")
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                           Spacer()
                                           Image(systemName: "sun.max")
                                               .font(.system(size: 60))
                                               .foregroundColor(.white.opacity(0.7))
                                       }
                

//                switch habit.wakeUpStatus {
//
//                case .active:
//                    Button("I'm awake") {
//                        habit.checkInWakeUp()
//                    }
//
//                case .completed:
//                    Text("proud!")
//
//                case .missed:
//                    Text("try again tomorrow")
//
//                case .upcoming:
//                    Text(" Not yet")
//
//                case .notSet:
//                    Text("Set your wake up time")
//                }
            }
            .padding()
            .background(habit.type.color)
            .frame(width: 168, height: 146)
            .cornerRadius(16)
        }
    }



#Preview {
    WakeUpHabitCardView(habit: PreviewData.wakeUpHabit)
        .padding()
}
