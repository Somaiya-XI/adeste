//
//  HabitsStaticLayoutView.swift
//  levelUp
//
//  Layout logic for 1-2-3 habits cases using frame extensions exclusively.
//

import SwiftUI

struct HabitsStaticLayoutView: View {
    let habits: [HabitDisplayData]
    
    var body: some View {
        switch habits.count {
        case 1:
            case1SingleHabit
        case 2:
            case2TwoHabits
        case 3:
            case3ThreeHabits
        default:
            EmptyView()
        }
    }
    
    // MARK: - Case 1: Single Habit/Athkar (345x243) - .large layout
    private var case1SingleHabit: some View {
        AdaptiveHabitCard(
            habit: habits[0],
            layoutType: .large,
            waterFilledBottles: extractWaterBottles(from: habits[0])
        )
        .padding(.horizontal)
    }
    
    // MARK: - Case 2: Two Habits (both 345x117.5) - .wide layout
    private var case2TwoHabits: some View {
        VStack(spacing: 8) {
            AdaptiveHabitCard(
                habit: habits[0],
                layoutType: .wide
            )
            
            AdaptiveHabitCard(
                habit: habits[1],
                layoutType: .wide
            )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Case 3: Three Habits (top two: 168x128, bottom: 345x117.5)
    private var case3ThreeHabits: some View {
        VStack(spacing: 8) {
            // Row 1: Two SmallHabitCards (.small layout)
            HStack(spacing: 8) {
                AdaptiveHabitCard(
                    habit: habits[0],
                    layoutType: .small
                )
                
                AdaptiveHabitCard(
                    habit: habits[1],
                    layoutType: .small
                )
            }
            
            // Row 2: WideHabitCard (.wide layout)
            AdaptiveHabitCard(
                habit: habits[2],
                layoutType: .wide
            )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper: Extract water bottles from habit data
    private func extractWaterBottles(from habit: HabitDisplayData) -> Int? {
        // If habit has a value that represents bottles, extract it
        // Otherwise return nil to use default (3)
        if let value = habit.value, let bottles = Int(value) {
            return bottles
        }
        return nil
    }
}

// MARK: - Helper Data Structure
struct HabitDisplayData {
    let title: String
    let value: String?
    let unit: String?
    let subTitle: String?
    let iconName: String
    let isSystemIcon: Bool
    let backgroundColorName: String
    let textColorName: String?
    
    init(
        title: String,
        value: String? = nil,
        unit: String? = nil,
        subTitle: String? = nil,
        iconName: String,
        isSystemIcon: Bool = true,
        backgroundColorName: String,
        textColorName: String? = nil
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.subTitle = subTitle
        self.iconName = iconName
        self.isSystemIcon = isSystemIcon
        self.backgroundColorName = backgroundColorName
        self.textColorName = textColorName
    }
}

#Preview("Design System Audit - All Cases") {
    ScrollView {
        VStack(spacing: 40) {
            // Case 1: Single Habit (345x243)
            VStack(spacing: 12) {
                Text("--- Case 1: Single Habit ---")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)
                
                HabitsStaticLayoutView(habits: [
                    HabitDisplayData(
                        title: "Athkar",
                        subTitle: "MORNING",
                        iconName: "cloud.sun.fill",
                        backgroundColorName: "sec-color-mustard"
                    )
                ])
            }
            
            // Case 2: Two Habits (both 345x117.5)
            VStack(spacing: 12) {
                Text("--- Case 2: Two Habits ---")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)
                
                HabitsStaticLayoutView(habits: [
                    HabitDisplayData(
                        title: "Praying",
                        subTitle: "FJR",
                        iconName: "sunrise.fill",
                        backgroundColorName: "sec-color-berry"
                    ),
                    HabitDisplayData(
                        title: "Athkar",
                        subTitle: "MORNING",
                        iconName: "cloud.sun.fill",
                        backgroundColorName: "sec-color-mustard"
                    )
                ])
            }
            
            // Case 3: Three Habits (top two: 168x128, bottom: 345x117.5)
            VStack(spacing: 12) {
                Text("--- Case 3: Three Habits ---")
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.secondary)
                
                HabitsStaticLayoutView(habits: [
                    HabitDisplayData(
                        title: "Wake up",
                        value: "7:45",
                        unit: "PM",
                        iconName: "sun.max.fill",
                        isSystemIcon: true,
                        backgroundColorName: "sec-color-mustard",
                        textColorName: "brand-color"
                    ),
                    HabitDisplayData(
                        title: "Exercise",
                        value: "9,565",
                        unit: "Steps",
                        iconName: "ic_steps",
                        isSystemIcon: false,
                        backgroundColorName: "sec-color-berry",
                        textColorName: "white"
                    ),
                    HabitDisplayData(
                        title: "Praying",
                        subTitle: "FJR",
                        iconName: "sunrise.fill",
                        backgroundColorName: "sec-color-berry"
                    )
                ])
            }
        }
        .padding(.vertical, 20)
    }
    .background(Color(.systemGroupedBackground))
}
