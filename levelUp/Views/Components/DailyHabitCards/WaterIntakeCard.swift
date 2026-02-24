//
//  WaterIntakeCard.swift
//  levelUp
//
//  Created on 11/02/2026.
//

import SwiftUI

struct WaterIntakeCard: View {
    let filledBottles: Int
    let totalBottles: Int
    
    init(filledBottles: Int = 3, totalBottles: Int = 8) {
        self.filledBottles = filledBottles
        self.totalBottles = totalBottles
    }
    
    var body: some View {
        ZStack {
             RoundedRectangle(cornerRadius: 16)
                .fill(Color("sec-color-blue"))
                .waterCardFrame()
         
            VStack(spacing: 8) {
               
                HStack(spacing: 8) {
                    ForEach(0..<totalBottles, id: \.self) { index in
                        Image(systemName: index < filledBottles ? "waterbottle.fill" : "waterbottle")
                            .font(.s32Medium)
                            .foregroundStyle(Color.white)
                    }
                }
                
                 Text("Water intake")
                    .font(.s16Medium)
                    .foregroundStyle(Color.white)
                    .padding(.top, 8)
            }
            .padding(16)
        }
        .waterCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    WaterIntakeCard()
        .padding()
}
