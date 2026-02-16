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
                    HomeView()
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
            
            // Floating custom tab bar
            CustomTabBar(selectedTab: $selectedTab, namespace: tabAnimation)
                .padding(.bottom, 24)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
