//
//  HabitsSectionView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI


struct HabitsSectionView: View {
    let pages:[[Habit]]
    var body: some View {
           VStack(alignment: .leading, spacing: 6) {

               Text("Daily habit")
                   .font(.title2.bold())
                   .foregroundColor(.brand)
               if pages.count > 1 {
                   TabView {
                       ForEach(pages.indices, id: \.self) { index in
                           HabitsStaticLayoutView(habits: pages[index])
                               .padding(.horizontal)
                       }
                   }
                   
                   .tabViewStyle(.page(indexDisplayMode: .automatic))
                                  .frame(height: 320)
               }else if let firstPage = pages.first {
                   HabitsStaticLayoutView(habits: firstPage)
               }
               


           }
       }
}
#Preview("HabitsSection – Single Page") {

    HabitsSectionView(
        pages: [
            [
                Habit(title: "Water", type: .water),
                Habit(title: "Steps", type: .steps),
                Habit(title: "Wake Up", type: .wakeUp)
            ]
        ]
    )
    .padding()
  
}
