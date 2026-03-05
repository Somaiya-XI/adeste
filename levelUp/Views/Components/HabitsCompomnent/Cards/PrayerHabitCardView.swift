//
//  PrayerHabitCardView.swift
//  levelUp
//
//  Prayer habit card with dynamic prayer display
//

import SwiftUI

struct PrayerHabitCardView: View {
    @StateObject var viewModel: PrayerViewModel
    @ObservedObject private var prayerHabitManager = AppHabitPrayerManager.shared
    let layoutType: HabitLayoutType
    @State private var showErrorAlert = false
    
    init(habit: Habit, layoutType: HabitLayoutType = .wide) {
        _viewModel = StateObject(wrappedValue: PrayerViewModel(habit: habit))
        self.layoutType = layoutType
    }
    
    var body: some View {
        // Convert ViewModel + core habit state to HabitDisplayData
        let completedCount = Int(prayerHabitManager.status.currentCount)
        let progressText = "\(completedCount)/5"
        let subtitleText: String? = {
            if layoutType == .small {
                return progressText
            } else {
                return "\(viewModel.currentPrayer.displayName.uppercased()) • \(progressText)"
            }
        }()

        let displayData = HabitDisplayData(
            title: "Praying",
            subTitle: subtitleText,
            iconName: viewModel.currentPrayer.iconName,
            isSystemIcon: true,
            backgroundColorName: "sec-color-berry",
            textColorName: "white"
        )
        
        ZStack(alignment: .topTrailing) {
            // Use AdaptiveHabitCard for beautiful UI
            AdaptiveHabitCard(
                habit: displayData,
                layoutType: layoutType,
                showCheckmarkOverlay: false
            )

            // Check-in button overlay
            Button {
                Task { await handleCheckInTap() }
            } label: {
                Image(systemName: viewModel.isCheckedIn ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.s20Medium)
                    .foregroundStyle(viewModel.isCheckedIn ? .white : .white.opacity(0.7))
            }
            .padding(8)
            .disabled(viewModel.isCheckedIn)
            .buttonStyle(.plain)
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
    
    @MainActor
    private func handleCheckInTap() async {
        let canCheck = await viewModel.canCheckIn()
        if canCheck {

            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            AppToastCenter.shared.show(message: "Saved!")

            await viewModel.checkIn()
        } else if !viewModel.isCheckedIn {
            viewModel.errorMessage = "You can only check in during \(viewModel.currentPrayer.displayName) prayer time."
            showErrorAlert = true
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
