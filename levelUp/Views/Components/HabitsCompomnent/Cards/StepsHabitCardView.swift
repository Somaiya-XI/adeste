//
//  StepsHabitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct StepsHabitCardView: View {
    @StateObject var viewModel: StepsViewModel
    @ObservedObject private var exerciseManager = AppHabitExerciseManager.shared
    let layoutType: HabitLayoutType  
    
    init(habit: Habit, layoutType: HabitLayoutType = .wide) {
        _viewModel = StateObject(wrappedValue: StepsViewModel(habit: habit))
        self.layoutType = layoutType
    }
    
    var body: some View {
        // Format steps count with comma separator
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let currentSteps = Int(exerciseManager.status.currentCount)
        let stepsString = formatter.string(from: NSNumber(value: currentSteps)) ?? "\(currentSteps)"
        
        // Convert ViewModel state to HabitDisplayData
        let displayData = HabitDisplayData(
            title: "Exercise",
            value: stepsString,
            unit: "Steps",
            iconName: "shoeprints.fill",
            isSystemIcon: true ,
            backgroundColorName: "sec-color-berry",
            textColorName: "white"
        )
        
        return AdaptiveHabitCard(
            habit: displayData,
            layoutType: layoutType
        )
        .onAppear {
            // Fetch steps when view appears
            Task {
                await exerciseManager.refreshSteps()
            }
        }
        .overlay(alignment: .bottomLeading) {
            // Show loading indicator
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .padding(16)
            }
        }
    }
}

#Preview {
    let habit = Habit(
        id: UUID().uuidString,
        title: "Steps",
        type: .steps,
        isEnabled: true
    )
    
    VStack(spacing: 16) {
        StepsHabitCardView(habit: habit, layoutType: .small)
        StepsHabitCardView(habit: habit, layoutType: .wide)
        StepsHabitCardView(habit: habit, layoutType: .large)
    }
    .padding()
}
