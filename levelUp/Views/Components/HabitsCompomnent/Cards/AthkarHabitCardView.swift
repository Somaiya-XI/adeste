//
//  AthkarHabitCardView.swift
//  levelUp
//
//  Athkar habit card with dynamic morning/evening display
//

import SwiftUI

struct AthkarHabitCardView: View {
    @StateObject var viewModel: AthkarViewModel
    let layoutType: HabitLayoutType
    @State private var showErrorAlert = false
    
    init(habit: Habit, layoutType: HabitLayoutType = .wide, athkarManager: AthkarManager) {
        _viewModel = StateObject(
            wrappedValue: AthkarViewModel(habit: habit, athkarManager: athkarManager)
        )
        self.layoutType = layoutType
    }
    
    var body: some View {
        // Convert ViewModel state to HabitDisplayData
        let displayData = HabitDisplayData(
            title: "Athkar",
            value: layoutType == .small ? viewModel.currentPeriod.displayName.uppercased() : nil,
            subTitle: layoutType != .small ? viewModel.currentPeriod.displayName.uppercased() : nil,
            iconName: viewModel.currentPeriod.iconName,
            isSystemIcon: true,
            backgroundColorName: viewModel.currentPeriod.backgroundColor,
            textColorName: viewModel.currentPeriod.textColor
        )
        
        ZStack(alignment: .topTrailing) {
            // Use AdaptiveHabitCard for beautiful UI
            AdaptiveHabitCard(
                habit: displayData,
                layoutType: layoutType
            )
            
            // Check-in button overlay
            Button {
                handleCheckInTap()
            } label: {
                Image(systemName: viewModel.isCheckedIn ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.s20Medium)
                    .foregroundStyle(viewModel.isCheckedIn ? Color.white : Color.white.opacity(0.7))
            }
            .padding(8)
            .disabled(viewModel.isCheckedIn)
        }
        .onAppear {
            // Load athkar period when view appears
            Task {
                await viewModel.updateCurrentPeriod()
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
        .alert("Cannot Check In", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    // Handle check-in with error handling
    private func handleCheckInTap() {
        Task {
            let canCheck = await viewModel.canCheckIn()
            
            if canCheck {
                await viewModel.checkIn()
            } else if !viewModel.isCheckedIn {
                // Outside athkar window
                viewModel.errorMessage = "You can only check in during \(viewModel.currentPeriod.displayName) athkar time."
                showErrorAlert = true
            }
        }
    }
}

#Preview {
    let athkarManager = AthkarManager(
        timesProvider: AdhanPrayerTimesProvider(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        store: UserDefaultsAthkarStore()
    )
    
    let habit = Habit(
        id: UUID().uuidString,
        title: "Athkar",
        type: .athkar,
        isEnabled: true
    )
    
    VStack(spacing: 16) {
        AthkarHabitCardView(habit: habit, layoutType: .small, athkarManager: athkarManager)
        AthkarHabitCardView(habit: habit, layoutType: .wide, athkarManager: athkarManager)
        AthkarHabitCardView(habit: habit, layoutType: .large, athkarManager: athkarManager)
    }
    .padding()
}
