
//
//  WakeUpHabitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI


struct WakeUpHabitCardView: View {
    @StateObject var viewModel: WakeUpViewModel
    let layoutType: HabitLayoutType  // ← NEW: Add this parameter
    @State private var showMissedAlert = false
    init(habit: Habit, layoutType: HabitLayoutType = .wide) {
        _viewModel = StateObject(
            wrappedValue: WakeUpViewModel(
                habit: habit,
                wakeUpTime: Calendar.current.date(
                    bySettingHour: 7,
                    minute: 45,
                    second: 0,
                    of: Date()
                )!
            )
        )
        self.layoutType = layoutType
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
            // Use AdaptiveHabitCard for beautiful UI
            AdaptiveHabitCard(
                habit: displayData,
                layoutType: layoutType
            )
            
            // Check-in button overlay
            Button {
                handleCheckInTap()
            } label: {
                Image(systemName: viewModel.didCheckIn ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.s20Medium)
                    .foregroundStyle(viewModel.didCheckIn ? Color.white : Color.white.opacity(0.7))
            }
            .padding(8)
            .disabled(viewModel.didCheckIn)
        }
        .alert("Missed Wake Up Window", isPresented: $showMissedAlert) {
            Button("OK", role: .cancel) {
                print("❌ User dismissed missed alert")
            }
        } message: {
            Text("You can only check in within 30 minutes of your wake up time (\(timeString) \(ampm)).")
        }
    }
    // Handle check-in with alert
    private func handleCheckInTap() {
        print("🔍 handleCheckInTap called")
        print("   canCheckIn: \(viewModel.canCheckIn())")
        print("   didCheckIn: \(viewModel.didCheckIn)")
        
        if viewModel.canCheckIn() {
            print("✅ Within window - checking in")
            viewModel.checkIn()
        } else if !viewModel.didCheckIn {
            print("⚠️ Outside window - showing alert")
            showMissedAlert = true
        } else {
            print("ℹ️ Already checked in - doing nothing")
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
        WakeUpHabitCardView(habit: habit, layoutType: .small)
        WakeUpHabitCardView(habit: habit, layoutType: .wide)
        WakeUpHabitCardView(habit: habit, layoutType: .large)
    }
    .padding()
}



