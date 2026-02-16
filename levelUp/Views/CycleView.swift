//
//  CycleView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI
import SwiftData

struct CycleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [
        SortDescriptor(\Cycle.title),
    ]) var cycles: [Cycle]
    
    @State var vm: CycleViewModel = .init()
    @State var currentPage = 0
    
    var body: some View {
        @Bindable var vm = vm
        NavigationStack{
            GeometryReader {
                let size = $0.size
                let h = size.height
                
                VStack(spacing: 0) {
                    // Top Logo Section
                    Text("Pick your commitment style")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.brandGrey)
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
                    // Page Indicator
                    PageIndicator(numberOfPages: cycles.count, currentPage: currentPage)
                        .padding(.top, 30)
                    
                    Spacer()
                }
                
            }
            .navigationDestination(isPresented: $vm.isCompleted) {
                HabitPickerView(habitLimit: vm.currentCycle?.maxHabits ?? 0 )
            }
            .onAppear {
                vm.configure(with: modelContext)
                
            }
        }
    }
}

