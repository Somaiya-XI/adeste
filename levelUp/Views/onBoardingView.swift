//
//  CycleView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI
import SwiftData

struct OnBoarding: View {
    @State private var showStartCycle = false
    @State private var userName = ""
    
    var body: some View {
        NavigationStack {
            StartingView(onContinue: {
                showStartCycle = true
            })
            .navigationDestination(isPresented: $showStartCycle) {
                StartCycle()

            }
        }
    }
}

#Preview {
    NavigationStack {
        OnBoarding()
    }
}

struct StartingView: View {
    @State var onContinue:() -> Void
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let w = size.width
           
            VStack(spacing: 60) {
                
                VStack(spacing: 0) {
                    Text("Adeste")
                        .font(.custom("TBJ Matte Nature DEMO", size: 80, relativeTo: .largeTitle))
                        .foregroundStyle(.brand)
                        .dynamicTypeSize(...DynamicTypeSize.accessibility1)

                    Text("Detox your doomscrolling at your fingertips")
                        .font(.s18Medium)
                        .foregroundStyle(.brandGrey)
                }.multilineTextAlignment(.center)

                    Image("im_mc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: w * 0.49)
                
                Spacer()

                
                // Continue Button
                Button {
onContinue()
                } label: {
                    Text("Begin")
                        .font(.s18Semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 32)
                                .fill(Color.brand)
                        )
                }

               
            }
            .padding(.top, 145)
                .padding(.bottom, 26)
                .padding(.horizontal, 56)
            .frame(maxWidth: .infinity)
        }.background(.baseShade01)

    }
}
