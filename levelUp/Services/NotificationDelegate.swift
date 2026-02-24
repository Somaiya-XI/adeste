//
//  NotificationDelegate.swift
//  adeste
//
//  Created by Somaiya on 22/08/1447 AH.
//


import UserNotifications
import SwiftData

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        // Check for intention id within the response
        guard let intentionId = response.notification.request.content.userInfo["intentionId"] as? String else {
            print("No intention ID in notification")
            completionHandler()
            return
        }
        
        // Get the user choice from action identifier
        let actionIdentifier = response.actionIdentifier
        
        
        // Retrieve the intention from the DB context
        Task { @MainActor in
            let container = try? ModelContainer(for: Intention.self)
            guard let context = container?.mainContext else {
                completionHandler()
                return
            }
            
            //
            let manager = IntentionManager(modelContext: context)
            
            let descriptor = FetchDescriptor<Intention>(
                predicate: #Predicate { $0.id == intentionId }
            )
            print("delegate intent: \(intentionId)")
            //Record user choice foucs/distraction based on the click
            if let intention = try? context.fetch(descriptor).first {
                switch actionIdentifier {
                case "FOCUS_ACTION":
                    print("Focus recorded for \(intention.title)")
                    manager.registerFocus(for: intention)
                    
                case "DISTRACTION_ACTION":
                    print("Distraction recorded for \(intention.title)")
                    manager.registerDistraction(for: intention)
                    
                default:
                    break
                }
            }
            
            completionHandler()
        }
    }
    
    // Handle notifications when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is open
        completionHandler([.banner, .sound, .badge])
    }
}
