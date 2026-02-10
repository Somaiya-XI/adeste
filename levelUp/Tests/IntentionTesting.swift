//
//  IntentionTesting.swift
//  Adeste
//
//  Created by Somaiya on 21/08/1447 AH.
//

import SwiftUI
import SwiftData

struct IntentionTestingView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var intentions: [Intention]
    @State private var vm = IntentionsViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            let summary = vm.getIntentionsSummary()
            
            Button("Add new Intention") {
                vm.addIntention(title: "New Intention")
            }
            
            Text("Focus: \(summary.focusPercentage, format: .number.precision(.fractionLength(2)))%")
            
            Text("Distraction: \(summary.distractionPercentage, format: .number.precision(.fractionLength(2)))%")
            
            ForEach(intentions) { intention in
                HStack {
                    Text(intention.title)
                    
                    Button("record focus") {
                        vm.recordFocus(for: intention)
                    }
                    
                    Button("record distraction") {
                        vm.recordDistraction(for: intention)
                    }
                }
            }
        }
        .padding()
        
        .onAppear {
            vm.configure(with: modelContext)
            
        }.onChange(of: intentions) {
            print(intentions.count)
        }
    }
}
#Preview {
    IntentionTestingView()
}
