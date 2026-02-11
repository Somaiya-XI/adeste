//
//  StartCycle.swift
//  levelUp
//
//  Created by Manar on 09/02/2026.
//

import SwiftUI

struct StartCycle: View {
    @State private var currentPage = 0
    @State private var goToPickHabit = false
    @State private var selectedLimit = 2

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    Color(red: 0.98, green: 0.98, blue: 0.98)
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        // Top Logo Section
                        VStack(spacing: 10) {
                            Circle()
                                .fill(Color(red: 0.85, green: 0.55, blue: 0.70))
                                .frame(width: 60, height: 60)

                            Text("our slogan")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.6))
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 30)

                        // Card Carousel
                        ZStack {
                            HStack(spacing: 0) {
                                if currentPage > 0 {
                                    Color.clear
                                        .frame(width: 40)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .fill(Color(red: 0.87, green: 0.76, blue: 0.61).opacity(0.3))
                                                .padding(.vertical, 40)
                                        )
                                }

                                Spacer()

                                if currentPage < 2 {
                                    Color.clear
                                        .frame(width: 40)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .fill(Color(red: 0.87, green: 0.76, blue: 0.61).opacity(0.3))
                                                .padding(.vertical, 40)
                                        )
                                }
                            }

                            // Main cards - Limits
                            TabView(selection: $currentPage) {
                                CycleCard(title: "7 Days Cycle") {
                                    selectedLimit = 2
                                    goToPickHabit = true
                                }
                                .tag(0)

                                CycleCard(title: "14 Days Cycle") {
                                    selectedLimit = 3
                                    goToPickHabit = true
                                }
                                .tag(1)

                                CycleCard(title: "21 Days Cycle", customIcon: "Fire-expression") {
                                    selectedLimit = 5
                                    goToPickHabit = true
                                }
                                .tag(2)
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                        }
                        .frame(height: 520)

                        // Page Indicator
                        PageIndicator(numberOfPages: 3, currentPage: currentPage)
                            .padding(.top, 30)

                        Spacer()
                    }
                }
            }
            .navigationDestination(isPresented: $goToPickHabit) {
                HabitPickerView(habitLimit: selectedLimit)
            }
        }
    }
}

// CycleCard Component
struct CycleCard: View {
    let title: String
    var customIcon: String? = nil
    let onGetStarted: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Header Section
            HStack(spacing: 16) {
                if let iconName = customIcon {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.4))
                        .frame(width: 50, height: 50)
                }

                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.35, green: 0.08, blue: 0.08))
                    .lineLimit(1)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.87, green: 0.76, blue: 0.61))

            // Content Section
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Description of the cycle")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black.opacity(0.9))

                    Text("aaaaaaaaaaovkfbojopjbo prekbopjeropbjoperjbopkrbopkeropbk")
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.7))
                        .lineLimit(2)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Features:")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(red: 0.35, green: 0.08, blue: 0.08))

                    FeatureRow(
                        icon: "heart.fill",
                        iconColor: Color(red: 0.65, green: 0.35, blue: 0.45),
                        text: "Reward"
                    )

                    FeatureRow(
                        icon: "clock.fill",
                        iconColor: Color(red: 0.45, green: 0.60, blue: 0.70),
                        text: "Mood"
                    )

                    FeatureRow(
                        icon: "star.fill",
                        iconColor: Color(red: 0.95, green: 0.70, blue: 0.35),
                        text: "Reward"
                    )
                }

                Spacer(minLength: 20)

                // Get Started Button
                Button {
                    onGetStarted()
                } label: {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(red: 0.35, green: 0.08, blue: 0.08))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            Capsule()
                                .stroke(Color(red: 0.35, green: 0.08, blue: 0.08), lineWidth: 2.5)
                        )
                }
                .padding(.bottom, 34)
            }
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(red: 0.96, green: 0.91, blue: 0.84))
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 28)
    }
}

// FeatureRow Component
struct FeatureRow: View {
    let icon: String
    let iconColor: Color
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 28, height: 28)

            Text(text)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(iconColor)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - PageIndicator Component
struct PageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage
                          ? Color(red: 0.35, green: 0.08, blue: 0.08)
                          : Color.gray.opacity(0.25))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentPage ? 1.0 : 0.8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    StartCycle()
}
