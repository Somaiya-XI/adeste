//
//  intentionAlert.swift
//  adeste
//
//  Created by Somaiya on 23/08/1447 AH.
//

import SwiftUI

struct intentionAlert: View {
    @Environment(\.dismiss) var dismiss
    var vm: IntentionsViewModel
    var body: some View {
        @Bindable var vm = vm
        ZStack{
               }
        .alert("How have yow handled \(vm.currentIntention?.title ?? "Intention")", isPresented: $vm.showStopwatchAlert) {
                   
            Button("Focused", role: .confirm) {
                guard let intention = vm.currentIntention else { return }
                vm.recordFocus(for: intention)
                vm.currentIntention = nil
                vm.viewMode = .main
                
                dismiss()
            }.keyboardShortcut(.defaultAction)
            
            Button("Got Distracted") {
                guard let intention = vm.currentIntention else { return }
                vm.recordDistraction(for: intention)
                vm.currentIntention = nil
                vm.viewMode = .main
                       dismiss()
                   }
            Button("Stop Anyway", role: .cancel) {
                vm.currentIntention = nil
                vm.viewMode = .main
                       dismiss()
            }
               } message: {
                   Text("If you tap stop now, your intention summary won't be calculated.")
               }
               .padding(.horizontal, 17)
               .padding(.vertical, 32)
    }
}

#Preview {
    intentionAlert(vm: IntentionsViewModel())
}
