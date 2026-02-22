//
//  StreakView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct StreakView: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.baseShade01)
                .frame(width: 80, height: 32)
                .overlay(
                    Text("Streak")
                        .font(.s12Medium)
                        .foregroundColor(.gray)
                )

            Spacer()
        }
    }
}

#Preview {
    StreakView()
}
