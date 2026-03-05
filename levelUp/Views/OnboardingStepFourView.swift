//
//  OnboardingStepFourView.swift
//  levelUp
//
//  Reuses PickHabit habit data, selection logic, and icon mapping (HabitCardIconView).
//

import SwiftUI

/// Same 5 habits and icon mapping as PickHabit (HabitPickerView).
private let onboardingHabitOptions: [(title: String, icon: HabitCard.IconType)] = [
    ("Walk", .system("figure.walk.motion")),
    ("Drink Water", .singleBottle),
    ("Wake Up", .system("sun.max.fill")),
    ("Athkar", .system("book.fill")),
    ("Pray", .custom("Mosque"))
]

struct OnboardingStepFourView: View {
    let cycle: Cycle
    @State private var selectedHabits: Set<String> = []
    @Environment(\.dismiss) var dismiss
    //
    @State private var showGoalSheet = false
    @State private var wakeUpTime: Date = Calendar.current.date(
        bySettingHour: 7, minute: 0, second: 0, of: Date()
    ) ?? Date()
    @State private var stepGoal: Int = 8000
    @State private var hasCompletedOnboarding = false
    @State var goToNext: Bool = false
    
    /// Tracks if user came from Settings to change cycle (vs initial onboarding)
    @State private var isChangingCycle = false

    // Map habit names to HabitType
    private let habitTypeMap: [String: HabitType] = [
        "Pray": .prayer,
        "Drink Water": .water,
        "Walk": .steps,
        "Athkar": .athkar,
        "Wake Up": .wakeUp
    ]
    @State private var showWakeUpTimePopup = false
    @State private var selectedWakeUpTime = Date()
    
    var body: some View {
        ZStack {
            Color("base-shade-01")
                .ignoresSafeArea()
            
            
            // Back Button
            GeometryReader{_ in
                Button { dismiss() }
                label:{ Image(.icBack) }
                    .padding(.top, 12)
                    .padding(.leading, 24)
            }
            
            VStack(spacing: 0) {

                // Header
                Text("Choose your habits")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color("brand-color"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 28)

                // Habit list — same data and selection logic as PickHabit
                VStack(spacing: 24) {
                    ForEach(onboardingHabitOptions, id: \.title) { option in
                        OnboardingHabitRow(
                            title: option.title,
                            icon: option.icon,
                            isSelected: selectedHabits.contains(option.title)
                        ) {
                            toggleHabit(option.title)
                        }
                    }
                }

          Spacer()
                
                Button {

                    let needsGoalSheet = selectedHabits.contains("Wake Up") || selectedHabits.contains("Walk")
                    if needsGoalSheet {
                        showGoalSheet = true
                    } else {
                        saveHabitsAndCompleteOnboarding()
                        if isChangingCycle {
                            dismiss()
                        } else {
                            goToNext = true
                        }
                    }

                } label: {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(selectedHabits.count > 0 ? .brand : .gray)
                        .clipShape(Capsule())
                }
                .disabled(selectedHabits.isEmpty)
                .buttonStyle(.plain)
                
            }.padding(.top, 68)
            .padding(.bottom, 26)
            .padding(.horizontal, 56)
        }  .navigationDestination(isPresented: $goToNext) {
            // Only navigate forward during initial onboarding
            OnboardingStepFiveView()
        }.navigationBarBackButtonHidden()
            .sheet(isPresented: $showGoalSheet) {
                HabitsGoalSheet(
                    selectedHabits: selectedHabits,
                    selectedWakeUpTime: $wakeUpTime,
                    stepGoal: $stepGoal,
                    isOnboarding: false,
                    cycleType: cycle.cycleType
                )
                .presentationDetents([.large])
                .onDisappear {
                    saveHabitsAndCompleteOnboarding()
                    if !isChangingCycle {
                        // Defer navigation to let sheet dismissal animation complete
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            goToNext = true
                        }
                    }
                }
            }
            .onAppear {
                UserManager.shared.loadOnboardingState()
                // Capture if user is already onboarded (changing cycle from settings)
                isChangingCycle = UserManager.shared.isOnboardingComplete
            }
    }

    /// Same toggle logic as PickHabit (HabitPickerView.toggleHabit).
    private func toggleHabit(_ habit: String) {
        if selectedHabits.contains(habit) {
            selectedHabits.remove(habit)
        } else {
            if selectedHabits.count < cycle.maxHabits{
                selectedHabits.insert(habit)
            }
        }
    }
    
    private func saveHabitsAndCompleteOnboarding() {
        guard !hasCompletedOnboarding else { return }
        hasCompletedOnboarding = true
        // Convert selected habit names to Habit objects
        let habits: [Habit] = selectedHabits.compactMap { habitName in
            guard let habitType = habitTypeMap[habitName] else { return nil }
            return Habit(title: habitName, type: habitType, isEnabled: true)
        }
        
        // Save all user data at once (single write)
        let userManager = UserManager.shared
        // Create user if doesn't exist
        if userManager.currentUser == nil {
            userManager.createUser(name: "")
        }
        userManager.currentUser?.currentCycleId = cycle.id
        userManager.currentUser?.habits = habits
        userManager.saveUser()
        
        // Request HealthKit only if Walk was selected
        if selectedHabits.contains("Walk") {
            Task {
                try? await HealthManager.shared.requestAuthorization()
            }
        }
        
    }
}

// MARK: - Row style matching onboarding design (icon + text, border when selected)
private struct OnboardingHabitRow: View {
    let title: String
    let icon: HabitCard.IconType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                HabitCardIconView(
                    icon: icon,
                    font: .system(size: 24, weight: .semibold, design: .rounded),
                    customImageSize: 28
                )
                Text(title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("brand-color"))
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .frame(height: 66)
            .background(Color("base-shade-02"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color("brand-color") : Color.clear, lineWidth: 2.5)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OnboardingStepFourView(cycle: Cycle(cycleType: .advanced, cycleDuration: .advanced, desc:
                                            "")
            )
}
