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
        HStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.baseShade01)
                .frame(width: 110, height: 32)
                .overlay(
                    HStack(spacing: 6) {
                        Image(systemName:"flame.fill")
                            .font(.s12Medium)
                            .foregroundColor(.brand)
                        Text("\(streakManager.streakCount)")
                            .font(.s12Medium)
                            .foregroundStyle(.brand)
                    }
                )

            Spacer()
        }
    }
}

#Preview {
    StreakView()
}
