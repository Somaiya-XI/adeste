//
//  NotificationManager.swift
//  Adeste
//
//  Created by Somaiya on 21/08/1447 AH.
//

import Foundation
import UserNotifications


class NotificationManager {
    static let obj = NotificationManager()
    var isNotificationEnabled: Bool = false
    func requestPermission(){
        let options: UNAuthorizationOptions = [.alert, .badge, .criticalAlert, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            
            if let error = error {
                print("Erorr: \(error.localizedDescription)")
                NotificationManager.obj.isNotificationEnabled = false
            } else if granted {
                print("Success")
                NotificationManager.obj.isNotificationEnabled = true
            } else {
                print("Access denied")
                NotificationManager.obj.isNotificationEnabled = false
            }
        }
    }
    
    func triggerScheduledNotification(for content: [String: String], triggerInterval: TimeInterval, category: String? = "") {
        
        
        let notificationContent = UNMutableNotificationContent()
        
        guard let title = content["title"], let body = content["body"] else { return }
        
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = UNNotificationSound.default
        notificationContent.categoryIdentifier = category ?? ""
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerInterval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("notification is firing in \(triggerInterval) seconds")
            }
        }
    }
    
    func setupNotificationCategory() {
        
        // 1. Define actions
        let focusAction = UNNotificationAction(
            identifier: "FOCUS_ACTION",
            title: "Focused",
            options: []
        )
        
        let distractionAction = UNNotificationAction(
            identifier: "DISTRACTION_ACTION",
            title: "Got distracted",
            options: [.destructive]
        )
        
        let dismissAction = UNNotificationAction(
            identifier: "DISMISS_ACTION",
            title: "Dismiss",
            options: []
        )
        
        // 2. Create a category with these actions
        let category = UNNotificationCategory(
            identifier: "INTENTION_CATEGORY",
            actions: [focusAction, distractionAction, dismissAction],
            intentIdentifiers: [],
            options: []
        )
        
        // 3. Register the category
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }

    
    func triggerScheduledIntentionNotification(for intention: Intention, triggerInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Intention Check"
//        content.body = "How did you handle '\(intention.title)'?"
        content.body = "You opened your phone for '\(intention.title)' Did you finish?"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "INTENTION_CATEGORY"
        
        // Store the intention ID in userInfo
        content.userInfo = ["intentionId": intention.id]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(intention.title)")
            }
        }
    }
}
