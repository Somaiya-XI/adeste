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

struct NotificationTestingView: View {
    @AppStorage("counter") var counter: Int = 0

    @Environment(\.modelContext) private var modelContext
    @State var screenTimeManager  = ScreenTimeManager()
    @State private var pickerIsPresented = false
    @State private var activitySelection = FamilyActivitySelection()
    var myIntent = Intention(title: "Texting", icon: "message.badge.filled.fill")
    @Query var intentions: [Intention]
    @State private var vm = IntentionsViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("count is: \(counter)")
            
            Button("Notify me") {
                
                print(NotificationManager.obj.isNotificationEnabled)

                if !NotificationManager.obj.isNotificationEnabled {
                    NotificationManager.obj.requestPermission()
                } else {
//                    NotificationManager.obj.triggerScheduledNotification()
                    NotificationManager.obj.setupNotificationCategory()
                    vm.triggerNotification(for: myIntent)
                }
            }
            
        }.onAppear{
            Task {
                await screenTimeManager.requestAuthorization()
            }
            vm.configure(with: modelContext)
            
        }.onChange(of: intentions) {
            print(intentions.count)
        }
    }
}
#Preview {
    NotificationTestingView()
}


//                        if stopwatchTime == 0 {
//selectedIntentionIcon = nil
//let theintention = intentions.randomElement()!
//NotificationManager.obj.setupNotificationCategory()
//vm.triggerNotification(for: theintention)
//}
