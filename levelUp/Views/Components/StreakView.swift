//
//  StreakView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct StreakView: View {
    @ObservedObject private var streakManager = AppStreakManager.shared

    var body: some View {

        let isActive = streakManager.streakCount > 0
        
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.baseShade01)
                .frame(width: 90, height: 32)
                .overlay(
                    HStack(spacing: 6) {
                        Image(systemName: isActive ? "flame.fill" : "flame")
                            .font(.s12Medium)
                            .foregroundColor(isActive ? .brand : .gray.opacity(0.6))
                        
                        Text("\(streakManager.streakCount)")
                            .font(.s12Medium)
                            .foregroundStyle(isActive ? Color.brand : Color.gray.opacity(0.6))
                    }
                )

            Spacer()
        }
    }
}

#Preview {
    StreakView()
}
