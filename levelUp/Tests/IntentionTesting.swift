//
//  IntentionTesting.swift
//  levelUp
//
//  Created by Somaiya on 21/08/1447 AH.
//

import SwiftUI
import SwiftData

struct IntentionTestingView: View {
    @Environment(\.modelContext) private var modelContext
    @State var intentions: [Intention] = []
    @State private var vm = IntentionsViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            let summary = vm.getIntentionsSummary()
            
            Text("Focus: \(summary.focusPercentage, format: .number.precision(.fractionLength(2)))%")
            Text("Distraction: \(summary.distractionPercentage, format: .number.precision(.fractionLength(2)))%")
            
            ForEach(intentions) { intention in
                HStack {
                    Text(intention.title)
                    Text("F: \(intention.focus, format: .number)")
                    Text("D: \(intention.distraction, format: .number)")
                    
                    Button("+Focus") {
                        vm.recordFocus(for: intention)
                    }
                    
                    Button("+Distraction") {
                        vm.recordDistraction(for: intention)
                    }
                }
            }
            
            Button("Add Intention") {
                vm.addIntention(title: "New Intention")
            }
        }
        .padding()
        .onAppear {
            vm.configure(with: modelContext)
            intentions = vm.getIntentions()
        }.onChange(of: intentions) {
            print(intentions.count)
        }
    }
}
#Preview {
    IntentionTestingView()
}
