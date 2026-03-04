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
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [
        SortDescriptor(\Cycle.title),
    ]) var cycles: [Cycle]
    
    @State var vm: CycleViewModel = .init()
    @State var currentPage = 0
    
    var body: some View {
        @Bindable var vm = vm
        
        VStack(spacing: 0) {
            Text("Find your flow")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.brandGrey)
                .padding(.bottom, 30)
            
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(Array(cycles.enumerated()), id: \.element.id) { index, cycle in
                        CycleCard(cycle: cycle, onGetStarted: {
                            UserManager.shared.updateCycle(cycle.id)
                            dismiss()
                        }, onGoBack: {
                            dismiss()
                        })
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            PageIndicator(numberOfPages: cycles.count, currentPage: currentPage)
                .padding(.top, 30)
            
            Spacer()
        }
        .onAppear {
            vm.configure(with: modelContext)
        }
    }
}
