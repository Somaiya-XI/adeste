//
//  StepsHabitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct StepsHabitCardView: View {
    @StateObject  var viewModel: StepsViewModel
    
    init(habit: Habit) {
           _viewModel = StateObject(wrappedValue: StepsViewModel(habit: habit))
       }
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
                       Text("\(viewModel.stepsCount)")
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
                       .font(.system(size: 40))
                       .foregroundColor(.white.opacity(0.7))
               }
           }
           .padding()
           .frame(maxWidth: .infinity, maxHeight: .infinity)
           .background(Color.secColorBerry)
           .cornerRadius(16)
           .onAppear{
               Task {
                   try await HealthManager.shared.requestAuthorization()
               }
           }
       }
   }


#Preview {
    let habit = Habit(
        id: UUID().uuidString,
        title: "Steps",
        type: .steps,
        isEnabled: true
    )

    StepsHabitCardView(habit: habit)
        .padding()
}



