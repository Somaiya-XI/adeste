//
//  HabitCardView.swift
//  levelUp
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI

struct HabitCardView: View {
    let habit: Habit
    var onPlus: (() -> Void)?
      var onMinus: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 12) {

            Text(habit.title)
                .font(.headline)
                .foregroundColor(.white)
//
//            if habit.type == .water {
//                WaterBottlesView(filledCount: habit.waterIntake)
//
//         
//            }

            Spacer()
        }
        .padding(12)
        .frame(height: cardHeight)
        .frame(maxWidth: .infinity)
        .background(habit.habitColor)
        .cornerRadius(16)
        .onTapGesture {
            if habit.type == .water {
                Text("\(habit.waterIntake) cups")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                HStack(spacing: 16) {
                    Button {
                        onMinus?()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 28))
                    }
                    .disabled(habit.waterIntake == 0)

                    Button {
                        onPlus?()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                    }
                    .disabled(habit.waterIntake == 8)
                }
                .foregroundColor(.white)
            }

        }
    }

    private var cardHeight: CGFloat {
        switch habit.displayType {
        case .square: return 140
        case .rectangle: return 90
        case .fullWidth: return 180
        }
    }
}
