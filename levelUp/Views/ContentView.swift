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

    @State private var loader = SymbolLoader()
    @State private var userManager = UserManager.shared
    @State private var showWakeUpTimePopup = false
    @State private var selectedWakeUpTime = Date()

    var body: some View {
        Group {
                    if userManager.isOnboardingComplete {

                        NavigationStack {
                            HomeView(
                                showWakeUpTimePopup: $showWakeUpTimePopup,
                                selectedWakeUpTime: $selectedWakeUpTime
                            )
                        }
                    } else {
                        // Onboarding Flow
                        OnBoarding().background(.baseShade01)
                    }
                }
            }
        }
    
#Preview {
    ContentView()
}
