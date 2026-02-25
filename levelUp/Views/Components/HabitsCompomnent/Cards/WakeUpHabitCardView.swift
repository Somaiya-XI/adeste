
//
//  WakeUpHabitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI
import UIKit

struct WakeUpHabitCardView: View {
    @ObservedObject private var wakeUpManager = AppHabitWakeUpManager.shared
    @StateObject var viewModel: WakeUpViewModel
    let layoutType: HabitLayoutType
    @Binding var showWakeUpTimePopup: Bool
    @Binding var selectedWakeUpTime: Date
    @State private var showMissedAlert = false

    init(
        habit: Habit,
        layoutType: HabitLayoutType = .wide,
        showWakeUpTimePopup: Binding<Bool>,
        selectedWakeUpTime: Binding<Date>
    ) {
        _viewModel = StateObject(
            wrappedValue: WakeUpViewModel(
                habit: habit,
                wakeUpTime: AppHabitWakeUpManager.shared.wakeUpTime
            )
        )
        self.layoutType = layoutType
        _showWakeUpTimePopup = showWakeUpTimePopup
        _selectedWakeUpTime = selectedWakeUpTime
    }
    
    var body: some View {
        // Format time
        let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm"
            return formatter
        }()
        
        let ampmFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "a"
            return formatter
        }()
        
        let timeString = timeFormatter.string(from: viewModel.wakeUpTime)
        let ampm = ampmFormatter.string(from: viewModel.wakeUpTime)
        
        // Convert ViewModel state to HabitDisplayData
        let displayData = HabitDisplayData(
            title: "Wake up",
            value: timeString,
            unit: ampm,
            iconName: "sun.max",
            isSystemIcon: true,
            backgroundColorName: "sec-color-mustard",
            textColorName: "brand-color"
        )
        
        ZStack(alignment: .topTrailing) {
            AdaptiveHabitCard(
                habit: displayData,
                layoutType: layoutType
            )
            .onTapGesture {
                selectedWakeUpTime = wakeUpManager.wakeUpTime
                showWakeUpTimePopup = true
            }
            .onAppear {
                viewModel.wakeUpTime = wakeUpManager.wakeUpTime
            }
            .onChange(of: wakeUpManager.wakeUpTime) { _, newTime in
                viewModel.wakeUpTime = newTime
            }

            // Check-in button overlay
            Button {
                handleCheckInTap()
            } label: {
                Image(systemName: wakeUpManager.didCheckInToday ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.s20Medium)
                    .foregroundStyle(wakeUpManager.didCheckInToday ? Color.white : Color.white.opacity(0.7))
            }
            .padding(8)
            .disabled(wakeUpManager.didCheckInToday)
        }
        .alert(consts.WakeUpAlertTitleStr, isPresented: $showMissedAlert) {
            Button("OK", role: .cancel) {
                print("❌ User dismissed missed alert")
            }
        } message: {
            Text(consts.WakeUpAlertMessageStr)
        }
    }
    // Handle check-in with alert
    private func handleCheckInTap() {
        if wakeUpManager.didCheckInToday {
            return
        }
        if viewModel.canCheckIn() {
            wakeUpManager.checkIn()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            AppToastCenter.shared.show(message: "Progress Saved")
        } else {
            showMissedAlert = true
        }
    }
}

#Preview {
    let habit = Habit(
        id: UUID().uuidString,
        title: "Wake Up",
        type: .wakeUp,
        isEnabled: true
    )
    VStack(spacing: 16) {
        WakeUpHabitCardView(
            habit: habit,
            layoutType: .small,
            showWakeUpTimePopup: .constant(false),
            selectedWakeUpTime: .constant(Date())
        )
        WakeUpHabitCardView(
            habit: habit,
            layoutType: .wide,
            showWakeUpTimePopup: .constant(false),
            selectedWakeUpTime: .constant(Date())
        )
        WakeUpHabitCardView(
            habit: habit,
            layoutType: .large,
            showWakeUpTimePopup: .constant(false),
            selectedWakeUpTime: .constant(Date())
        )
    }
    .padding()
}



