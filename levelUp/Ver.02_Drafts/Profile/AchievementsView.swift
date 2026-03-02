//
//  AchievementsView.swift
//  levelUp
//

import SwiftUI

struct AchievementsView: View {
    @Environment(\.dismiss) private var dismiss

    // Sample data
    private let achievements: [Bool] = Array(repeating: true, count: 18)

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 18), count: 3)

    var body: some View {
        ZStack {
             Color.white
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Text(consts.achievementsStr)
                        .font(.s24Semibold)
                        .foregroundStyle(Color("brand-color"))

                    HStack {
                        BackButton(action: { dismiss() })
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                .padding(.bottom, 20)

                ScrollView {
                    VStack {
                        // Card container for the grid
                        LazyVGrid(columns: columns, spacing: 18) {
                            ForEach(achievements.indices, id: \.self) { index in
                                achievementSlot(index: index)
                            }
                        }
                        .padding(24) 
                        .frame(width: 361)
                        .background(Color("base-shade-02"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .frame(maxWidth: .infinity) // center horizontally
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    @ViewBuilder
    private func achievementSlot(index: Int) -> some View {
        Circle()
            .fill(Color("base-shade-01"))
            .frame(width: 98, height: 98)
    }
}

#Preview {
    NavigationStack {
        AchievementsView()
    }
}
