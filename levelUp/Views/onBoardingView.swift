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
            StartingView(onContinue: { name in
                userName = name
                showStartCycle = true
            })
            .navigationDestination(isPresented: $showStartCycle) {
                StartCycle(userName: userName)
                    .frame(height: 600)
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
    @State private var userName: String = ""
    @FocusState private var isNameFocused: Bool
    
    @State var onContinue: (String) -> Void
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let w = size.width
            
            VStack(alignment: .center, spacing: 24) {
                Spacer()
                
                HStack(alignment: .center, spacing: -8) {
                    Image("im_mc")
                        .resizable()
                        .scaledToFit()
                        .offset(x: -10)
                        .frame(width: w * 0.25)
                    
                    Text("Hi, Ade wants to know your name")
                        .font(.s24Medium)
                        .foregroundStyle(.secColorBerry)
                }
                
                VStack {
                    TextField("Enter your name", text: $userName)
                        .font(.s20Medium)
                        .foregroundStyle(Color("brand-color"))
                        .textFieldStyle(.plain)
                        .textInputAutocapitalization(.words)
                        .focused($isNameFocused)
                        .submitLabel(.continue)
                        .onSubmit {
                            if !userName.trimmingCharacters(in: .whitespaces).isEmpty {
                                onContinue(userName)
                            }
                        }
                    
                    Rectangle()
                        .fill(.brand)
                        .frame(height: 1)
                }
                .padding(.leading, 26)
                .frame(maxWidth: w * 0.9)
                
                // Continue Button
                Button {
                    if !userName.trimmingCharacters(in: .whitespaces).isEmpty {
                        onContinue(userName)
                    }
                } label: {
                    Text("Continue")
                        .font(.s18Semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(userName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.brand)
                        )
                }
                .disabled(userName.trimmingCharacters(in: .whitespaces).isEmpty)
                .padding(.horizontal, 26)
                .padding(.top, 20)
                
                Spacer()
                Spacer()
            }
            .frame(maxWidth: w * 0.9)
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            isNameFocused = true
        }
    }
}
