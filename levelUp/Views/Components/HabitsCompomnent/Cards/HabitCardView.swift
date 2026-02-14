//
//  HabitCardView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI

struct HabitCardView: View {
    let title: String
      let subtitle: String?
    let type : HabitType
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
                   Text(title)
                       .font(.headline)

                   if let subtitle {
                       Text(subtitle)
                           .font(.subheadline)
                           .foregroundColor(.white)
                           
                   }

                   Spacer()
               }
               .padding()
               .frame(height: 120)
               .frame(maxWidth: .infinity)
               
               .cornerRadius(20)
           }
    }

#Preview {
    VStack(spacing: 16) {
        HabitCardView(
            title: "Wake up",
            subtitle: "7:45 AM", type: .wakeUp
        )

        HabitCardView(
            title: "Exercise",
            subtitle: "9,565 steps", type: .steps
        )

        HabitCardView(
            title: "Only title",
            subtitle: nil, type: .water
        )
    }
    .padding()
}

