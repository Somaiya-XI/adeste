//
//  HabitPageView.swift
//  levelUp
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI

struct HabitPageView: View {
    let habits : [Habit]
    var onWaterTap:(() -> Void)?
    var body: some View {
        VStack(spacing: 8){
            if habits.count==3{
                VStack(spacing:8){
                    HStack(spacing:8){
                        
                        HabitCardView(habit: habits[0])
                        HabitCardView(habit: habits[1])
                    }
                    HabitCardView(habit: habits[2])
                }
            }
            else if habits.count==2{
                VStack(spacing: 8){
                    HabitCardView(habit: habits[0])
                    HabitCardView(habit: habits[1])
                }
            }
            else if habits.count==1{
                HabitCardView(habit: habits[0])
            }else{
                EmptyView()
            }
        }
    }
}

#Preview {
    HabitPageView(habits: [
        Habit(id: UUID().uuidString, title: "Water Intake", type: .water, isEnabled: true),
        Habit(id: UUID().uuidString, title: "Steps", type: .steps, isEnabled: true),
        Habit(id: UUID().uuidString, title: "Wake Up", type: .wakeUp, isEnabled: false)
    ])
}
