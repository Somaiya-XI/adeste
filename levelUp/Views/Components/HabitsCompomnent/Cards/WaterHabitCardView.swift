
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
    let layoutType: HabitLayoutType
    
    init(habit: Habit, layoutType: HabitLayoutType = .wide) {
        // Ensure water is never small
        let validLayoutType = layoutType == .small ? .wide : layoutType
        
        _viewModel = StateObject(
            wrappedValue: WaterViewModel(habit: habit)
        )
        self.layoutType = validLayoutType
    }
    
    var body: some View {
        // Convert ViewModel state to HabitDisplayData
        let displayData = HabitDisplayData(
            title: "Water intake",
            value: "\(viewModel.waterIntake)",
            unit: nil,
            iconName: "waterbottle.fill",
            isSystemIcon: true,
            backgroundColorName: "sec-color-blue",
            textColorName: "white"
        )
        
        ZStack(alignment: .topLeading) {
            // Use AdaptiveHabitCard for beautiful UI
            AdaptiveHabitCard(
                habit: displayData,
                layoutType: layoutType,
                waterFilledBottles: viewModel.waterIntake
            )
            
            
            interactiveControls        }
        
        
        // Match the card frame size
        .frame(
            width: 345,
            height: layoutType == .wide ? 117.5 : 243
        )
        .alert(consts.WaterAlertTitleStr, isPresented: $showAlert) {
            Button("OK") {}
        } message: {
            Text(consts.WaterAlertMessageStr)
            Text(consts.WaterAlertMessageStr)
        }
    }
    @ViewBuilder
    private var interactiveControls: some View {
        // Decrease button (bottom-left corner)
        Button {
            viewModel.decreaseWater()
        } label: {
            Image(systemName: "minus.circle.fill")
                .font(.title2)
                .foregroundStyle(Color.white)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        
        // Increase button (bottom-right corner)
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
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
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
