//
//  WaterHabitCardView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//
//

//  WaterHabitCardView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI

struct WaterHabitCardView: View {
    @StateObject var viewModel: WaterViewModel
    @State private var showAlert = false
    let layoutType: HabitLayoutType  // ← NEW: Add this parameter
    
    init(habit: Habit, layoutType: HabitLayoutType = .wide) {
        _viewModel = StateObject(
            wrappedValue: WaterViewModel(habit: habit)
        )
        self.layoutType = layoutType
    }
    
    var body: some View {
        // Convert ViewModel state to HabitDisplayData
        let displayData = HabitDisplayData(
            title: layoutType == .small ? "Water" : "Water intake",
            value: "\(viewModel.waterIntake)",
            unit: layoutType == .small ? "Bottles" : nil,
            iconName: "waterbottle.fill",
            isSystemIcon: true,
            backgroundColorName: "sec-color-blue",
            textColorName: "white"
        )
        
        ZStack {
            // Use AdaptiveHabitCard for beautiful UI
            AdaptiveHabitCard(
                habit: displayData,
                layoutType: layoutType,
                waterFilledBottles: viewModel.waterIntake
            )
            
            // Overlay interactive controls (only for wide/large)
            if layoutType != .small {
                interactiveControls
            }
        }
        .alert("Wait", isPresented: $showAlert) {
            Button("OK") {}
        } message: {
            Text("You can increase the number of water bottles only twice every 90 minutes")
        }
    }
    
    @ViewBuilder
    private var interactiveControls: some View {
        HStack {
            // Decrease button (left side)
            Button {
                viewModel.decreaseWater()
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.white)
            }
            .padding(.leading, 16)
            
            Spacer()
            
            // Increase button (right side)
            Button {
                if viewModel.canIncreaseWater() {
                    viewModel.increaseWater()
                } else {
                    showAlert = true
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color.white)
            }
            .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, layoutType == .wide ? 12 : 16)
    }
}

#Preview {
    let habit = Habit(
        id: UUID().uuidString,
        title: "Water Intake",
        type: .water,
        isEnabled: true
    )

    VStack(spacing: 16) {
        WaterHabitCardView(habit: habit, layoutType: .small)
        WaterHabitCardView(habit: habit, layoutType: .wide)
        WaterHabitCardView(habit: habit, layoutType: .large)
    }
    .padding()
}

