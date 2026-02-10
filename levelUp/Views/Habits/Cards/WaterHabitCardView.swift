//
//  WaterHabitCardView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//


import SwiftUI
struct WaterHabitCardView: View {
    var habit: Habit
    @State private var showAlert = false

    let maxBottles = 8

    var body: some View {
        VStack(spacing: 12) {

            // العنوان
            Text("Water intake")
                .font(.headline)
                .foregroundColor(.white)

            // الصف اللي فيه الأزرار والقوارير
            HStack(spacing: 12) {

                // ➖ زر النقصان
                Button {
                    if habit.waterIntake > 0 {
                        habit.waterIntake -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                        .font(.title3)
                }

                // 🧴 القوارير
                HStack(spacing: 6) {
                    ForEach(0..<maxBottles, id: \.self) { index in
                        Image(systemName:
                            index < habit.waterIntake
                            ? "waterbottle.fill"
                            : "waterbottle"
                        )
                        .foregroundColor(.white)
                    }
                }

                // ➕ زر الزيادة
                Button {
                    if habit.canIncreaseWater() {
                        habit.waterIntake += 1
                    } else {
                        showAlert = true
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
        }
        .padding()
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(Color.secColorBlue)
        .cornerRadius(20)
        .alert("wait", isPresented: $showAlert) {
            Button("okey") {}
        } message: {
            Text("you can increase the number of water bottles only twice every 90 minutes")
        }
    }
}

#Preview {
    let habit = Habit(
        id: UUID().uuidString,
        title: "Water",
        type: .water,
        isEnabled: true
    )

    WaterHabitCardView(habit: habit)
        .padding()
}

