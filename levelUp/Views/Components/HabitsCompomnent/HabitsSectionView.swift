//
//  HabitsSectionView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI


struct HabitsSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: -20) {
            // Header
            Text("Daily habit")
                .font(.s32Medium)
                .foregroundStyle(Color("brand-color"))
            
            // Carousel
            TabView {
                // Page 1: WakeUp + Exercise + WaterIntake
                VStack(spacing: 8) {
                    /// Row 1: Two SmallHabitCards
                    HStack(spacing: 8) {
                        SmallHabitCard(
                            title: "Wake up",
                            value: "7:45",
                            unit: "PM",
                            iconName: "sun.max.fill",
                            isSystemIcon: true,
                            backgroundColorName: "sec-color-mustard",
                            textColorName: "brand-color"
                        )
                        
                        SmallHabitCard(
                            title: "Exercise",
                            value: "9,565",
                            unit: "Steps",
                            iconName: "ic_steps",
                            isSystemIcon: false,
                            backgroundColorName: "sec-color-berry",
                            textColorName: "white"
                        )
                    }
                    
                    /// Row 2: WaterIntakeCard
                    WaterIntakeCard()
                }
                .padding(.horizontal)
                
                // Page 2: Prayer + Athkar
                VStack(spacing: 8) {
                    /// Row 1: Prayer Card (345 x 117.5, berry)
                    WideHabitCard(
                        title: "Praying",
                        subTitle: "FJR",
                        iconName: "sunrise.fill",
                        backgroundColorName: "sec-color-berry"
                    )
                    
                    /// Row 2: Athkar Card (345 x 117.5, mustard)
                    WideHabitCard(
                        title: "Athkar",
                        subTitle: "MORNING",
                        iconName: "cloud.sun.fill",
                        backgroundColorName: "sec-color-mustard"
                    )
                }
                .padding(.horizontal)
                
                // Page 3: Habit progress chart
                HabitProgressCard()
                    .padding(.horizontal)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 310)
        }
    }
}

#Preview {
    HabitsSectionView()
        .padding()
}
