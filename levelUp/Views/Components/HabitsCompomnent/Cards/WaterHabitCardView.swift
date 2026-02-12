//
//  WaterHabitCardView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//


import SwiftUI
struct WaterHabitCardView: View {
//    var habit: Habit
    @StateObject var viewModel: WaterViewModel
    @State  var showAlert = false

    
    init(habit: Habit) {
            _viewModel = StateObject(
                wrappedValue: WaterViewModel(habit: habit)
            )
        }
    
    var body: some View {
        VStack(spacing: 12) {
 
            Text("Water Intake")
                .font(.headline)
                .foregroundColor(.white)

            // الصف اللي فيه الأزرار والقوارير
            
            HStack(spacing: 12) {

                // ➖ زر النقصان
                Button {
                    viewModel.decreaseWater()
                } label: {
                    Image(systemName: "minus")
                        .foregroundColor(.white)
                        .font(.title3)
                }

                // 🧴 القوارير
                HStack(spacing: 6) {
                    ForEach(0..<viewModel.maxCups, id: \.self) { index in
                        Image(systemName:
                                index < viewModel.waterIntake
                            ? "waterbottle.fill"
                            : "waterbottle"
                        )
                        .foregroundColor(.white)
                    }
                }

                // ➕ زر الزيادة
                Button {
                    if viewModel.canIncreaseWater(){
                        viewModel.increaseWater()
                    } else { showAlert = true
                    }
                }label:{
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
        }
        .padding()
//        .frame(height: 120)
        .frame(maxWidth: .infinity, maxHeight: .infinity)  
        .background(Color.secColorBlue)
        .cornerRadius(16)
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
        title: "Water Intake",
        type: .water,
        isEnabled: true
    )

     WaterHabitCardView(habit: habit)
        .padding()
}



