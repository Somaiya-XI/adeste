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
    @Environment(\.modelContext) private var modelContext
    @State var screenTimeManager  = ScreenTimeManager()
    @State private var pickerIsPresented = false
    @State private var activitySelection = FamilyActivitySelection()
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Notify me") {
                
                print(NotificationManager.obj.isNotificationEnabled)

                if !NotificationManager.obj.isNotificationEnabled {
                    NotificationManager.obj.requestPermission()
                } else {
                    NotificationManager.obj.triggerScheduledNotification()
                }
            }
            
        }.onAppear{
            Task {
                await screenTimeManager.requestAuthorization()
            }
        }
    }
}
#Preview {
    NotificationTestingView()
}
