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
    @State private var selectedHabits: Set<String> = []

    var body: some View {
        ZStack {
            Color("base-shade-01")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 20)

                // Header
                Text("Choose your habits")
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundColor(Color("brand-color"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
                    .frame(height: 28)

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

                Spacer(minLength: 24)

                // Begin button
                Spacer(minLength: 20)

                Button {
                    // No navigation logic per requirements
                } label: {
                    Text("Begin")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 273, height: 54)
                        .background(Color("brand-color"))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 44)
        }
    }

    /// Same toggle logic as PickHabit (HabitPickerView.toggleHabit).
    private func toggleHabit(_ habit: String) {
        if selectedHabits.contains(habit) {
            selectedHabits.remove(habit)
        } else {
            selectedHabits.insert(habit)
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
            .frame(width: 273, height: 66)
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
    OnboardingStepFourView()
}
