//
//  IntentionTesting.swift
//  Adeste
//
//  Created by Somaiya on 21/08/1447 AH.
//

import SwiftUI
import SwiftData
import FamilyControls
import ManagedSettings

struct CycleTestingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [
        SortDescriptor(\Cycle.title),
    ]) var cycles: [Cycle]
    
    @State var vm: CycleViewModel = .init()
    @State var currentPage = 0
    
    var body: some View {
        @Bindable var vm = vm
        GeometryReader {
            let size = $0.size
            let w = size.width
            let h = size.height
            ZStack {
                Color(red: 0.98, green: 0.98, blue: 0.98)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Top Logo Section
                    VStack(spacing: 10) {
                        Text("Pick your style")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.brandGrey)
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 30)

                    // Card Carousel
                    VStack {
                        
                        // Main cards - Limits
                        TabView(selection: $currentPage) {
                            ForEach(Array(cycles.enumerated()), id: \.element.id) { index, cycle in
                                CycleCard(cycle: cycle) {
                                    vm.currentCycle = cycle
                                    vm.isCompleted = true
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                    }
                    .frame(height: h * 0.57)

                    // Page Indicator
                    PageIndicator(numberOfPages: cycles.count, currentPage: currentPage)
                        .padding(.top, 30)

                    Spacer()
                }
            }
        }
        .navigationDestination(isPresented: $vm.isCompleted) {
            HabitPickerView(habitLimit: vm.currentCycle?.maxHabits ?? 0 )
        }
    }
}
#Preview {
    CycleTestingView()
        .modelContainer(previewContainer2)

    
}


//                        if stopwatchTime == 0 {
//selectedIntentionIcon = nil
//let theintention = intentions.randomElement()!
//NotificationManager.obj.setupNotificationCategory()
//vm.triggerNotification(for: theintention)
//}
