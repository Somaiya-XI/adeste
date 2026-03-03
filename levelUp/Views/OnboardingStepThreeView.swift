//
//  OnboardingStepThreeView.swift
//  levelUp
//

import SwiftUI

struct OnboardingStepThreeView: View {
    var body: some View {
        ZStack {
            Color("base-shade-01")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 20)

                // 1. Header — large, dominant
                Text("That was the first step!")
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundColor(Color("brand-color"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
                    .frame(height: 32)

                // 2. Body text — medium, comfortable width
                Text("With your cycle, comes along your habits.\n\nHabits are the building blocks of your cycle and streak\n\nComplete them to progress!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 320)

                Spacer(minLength: 32)

                // 3. Next button — compact, near bottom
                Spacer(minLength: 24)

                Button {
                    // No navigation logic per requirements
                } label: {
                    Text("Next")
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
}

#Preview {
    OnboardingStepThreeView()
}
