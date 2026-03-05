//
//  OnboardingStepThreeView.swift
//  levelUp
//

import SwiftUI

struct OnboardingStepThreeView: View {
    @Environment(\.dismiss) var dismiss
    let cycle: Cycle
    @State var goToNext: Bool = false
    
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
            
            // Bg elements
            VStack{
                Spacer()
                Image("SketchyIcons")
                    .resizable()
                    .scaledToFit()
                
            }.padding(.bottom, 63)
            Rectangle().fill(.baseShade01.gradient.opacity(0.6)).padding(.top, 430).padding(.bottom, -34)
            
            
            VStack(spacing: 0) {
                
                // 1. Header — large, dominant
                Text("That was the first step!")
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundColor(Color("brand-color"))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 32)
                
                // 2. Body text — medium, comfortable width
                Text("With your cycle, comes along your habits.\n\nHabits are the building blocks of your cycle and streak\n\nComplete them to progress!")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    goToNext = true
                    // No navigation logic per requirements
                }label: {
                    Text("Continue")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(.brand)
                        .clipShape(Capsule())
                }.buttonStyle(.plain)
                .background(.baseShade01)
                .clipShape(Capsule())

                
                
            }.padding(.top, 68)
                .padding(.bottom, 26)
                .padding(.horizontal, 56)
            
        }.navigationDestination(isPresented: $goToNext) {
            OnboardingStepFourView(cycle: cycle)
            
        }
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    OnboardingStepThreeView(cycle: Cycle(cycleType: .advanced, cycleDuration: .advanced, desc:
                                            "")
    )
}
