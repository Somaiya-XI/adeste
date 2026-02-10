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
           VStack(alignment: .leading, spacing: 16) {

               Text("Daily habit")
                   .font(.title2)
                   .bold()
               if pages.count > 1 {
                   HabitsPagedLayoutView(pages: pages)
               }else if let firstPage = pages.first {
                   HabitsStaticLayoutView(habits: firstPage)
               }
               


           }
       }
}
#Preview {
    HabitsSectionView(pages: PreviewData.pages)
        .padding()
}
