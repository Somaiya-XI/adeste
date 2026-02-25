//
//  ContentView.swift
//  levelUp
//
//  Created by Somaiya on 16/08/1447 AH.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedTab: Tab = .home
    @Namespace private var tabAnimation

    @State private var loader = SymbolLoader()
    @State private var userManager = UserManager.shared
    @State private var showWakeUpTimePopup = false
    @State private var selectedWakeUpTime = Date()

    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        Group {
            if userManager.isOnboardingComplete {
                // Main App Content
                mainAppView
            } else {
                // Onboarding Flow
                OnBoarding()
            }
        }
    }
    
    private var mainAppView: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeView(
                            showWakeUpTimePopup: $showWakeUpTimePopup,
                            selectedWakeUpTime: $selectedWakeUpTime
                        )
                    }
                case .intentions:
                    IntentionsView()
                case .profile:
                    NavigationStack {
                        ProfileView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)

            CustomTabBar(selectedTab: $selectedTab, namespace: tabAnimation)
                .padding(.bottom, 24)

            // Wake-up time popup
            if showWakeUpTimePopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture { showWakeUpTimePopup = false }

                    WakeUpTimePopup(
                        isPresented: $showWakeUpTimePopup,
                        selectedWakeUpTime: $selectedWakeUpTime
                    )
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
