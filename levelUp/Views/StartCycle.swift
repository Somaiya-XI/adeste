//
//  StartCycle.swift
//  levelUp
//
//  Created by Manar on 09/02/2026.
//

import Foundation
import SwiftData

import SwiftUI

// MARK: - Main Onboarding View
struct OnboardingView: View {
    @State private var currentPage = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {

                Color(red: 0.98, green: 0.98, blue: 0.98)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    //  Logo
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
                            // الكارد اليسار
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
                        
                      // Main card
                        TabView(selection: $currentPage) {
                            CycleCard(title: "7 Days Cycle")
                                .tag(0)
                            
                            CycleCard(title: "14 Days Cycle")
                                .tag(1)
                            
                            CycleCard(title: "21 Days Cycle")
                                .tag(2)
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                    .frame(height: 500)
                    
                    // Custom Page Indicator
                    PageIndicator(numberOfPages: 3, currentPage: currentPage)
                        .padding(.top, 30)
                    
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Cycle Card Component
struct CycleCard: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Section
            HStack(spacing: 16) {
                Circle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 30)
                
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.35, green: 0.08, blue: 0.08))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("base-shade-02"))

            // Content Section
            VStack(alignment: .leading, spacing: 0) {
                // Description
                VStack(alignment: .leading, spacing: 4) {
                    Text("Description of the cycle")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black.opacity(0.9))
                    
                    Text("aaaaaaaaaaovkfbojopjboprekbopjeropbjoperjbopkrbopkeropbk")
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.7))
                        .lineLimit(2)
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
                
                // Features Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Features:")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(red: 0.35, green: 0.08, blue: 0.08))
                        .padding(.bottom, 4)
                    
                    FeatureRow(
                        icon: "heart.badge.bolt.fill",
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
                
                Button(action: {
                    print("Get Started tapped for: \(title)")
                }) {
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
            .background(Color("base-shade-01"))

        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 28)
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String          // SF Symbol name
    let iconColor: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 22))
                .frame(width: 28, height: 28)
            
            Text(text)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(iconColor)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - Page Indicator Component
struct PageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ?
                          Color(red: 0.35, green: 0.08, blue: 0.08) :
                          Color.gray.opacity(0.25))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentPage ? 1.0 : 0.8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
