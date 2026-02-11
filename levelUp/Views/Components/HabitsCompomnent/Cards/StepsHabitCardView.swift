//
//  StepsHabitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct StepsHabitCardView: View {
    var habit: Habit
    var body: some View {
           VStack(alignment: .leading, spacing: 8) {

               VStack(alignment: .leading) {
                   HStack {
                       Text("Steps")
                           .font(.headline)
                           .foregroundColor(.white)

                       Spacer()
                   }

                   HStack(alignment: .lastTextBaseline, spacing: 4) {
                       Text("\(habit.stepsCount)")
                           .font(.title.bold())
                           .foregroundColor(.white)

                       Text("steps")
                           .font(.subheadline)
                           .foregroundColor(.white.opacity(0.8))
                   }
               }

               HStack {
                   Spacer()
                   Image(systemName: "shoeprints.fill")
                       .font(.system(size: 60))
                       .foregroundColor(.white.opacity(0.7))
               }
           }
           .padding()
           .background(habit.type.color)
           .frame(width: 168, height: 146)
           .cornerRadius(16)
       }
   }


#Preview {
    StepsHabitCardView(habit: PreviewData.stepsHabit)
        .padding()
}

