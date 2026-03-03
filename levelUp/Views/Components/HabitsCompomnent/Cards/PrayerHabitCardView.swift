//
//  PrayerHabitCardView.swift
//  levelUp
//
//  Prayer habit card with dynamic prayer display
//

import SwiftUI

struct PrayerHabitCardView: View {
    @StateObject var viewModel: PrayerViewModel
    let layoutType: HabitLayoutType
    @State private var showErrorAlert = false
    
    init(habit: Habit, layoutType: HabitLayoutType = .wide) {
        _viewModel = StateObject(wrappedValue: PrayerViewModel(habit: habit))
        self.layoutType = layoutType
    }
    
    var body: some View {
        // Convert ViewModel state to HabitDisplayData
        let displayData = HabitDisplayData(
            title: "Praying",
            subTitle: viewModel.currentPrayer.displayName.uppercased(),
            iconName: viewModel.currentPrayer.iconName,
            isSystemIcon: true,
            backgroundColorName: "sec-color-berry",
            textColorName: "white"
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
            // Load prayer times and current prayer when view appears
            Task {
                await viewModel.updateCurrentPrayer()
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
                    
                    if let allHabits = UserManager.shared.currentUser?.habits {
                        AppStreakManager.shared.refreshForToday(habits: allHabits)
                        AppProgressManager.shared.updateProgress(habits: allHabits)
                    }
                    
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    AppToastCenter.shared.show(message: "Prayer completed!")
                } else if !viewModel.isCheckedIn {
                    // Outside prayer window
                    viewModel.errorMessage = "You can only check in during \(viewModel.currentPrayer.displayName) prayer time."
                    showErrorAlert = true
                }
            }
        }
}

#Preview {
    let habit = Habit(
        id: UUID().uuidString,
        title: "Praying",
        type: .prayer,
        isEnabled: true
    )
    
    VStack(spacing: 16) {
        PrayerHabitCardView(habit: habit, layoutType: .small)
        PrayerHabitCardView(habit: habit, layoutType: .wide)
        PrayerHabitCardView(habit: habit, layoutType: .large)
    }
    .padding()
}
