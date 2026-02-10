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
    
    func triggerScheduledNotification(for content: [String: String], triggerInterval: TimeInterval) {
        
        
        let notificationContent = UNMutableNotificationContent()
        
        guard let title = content["title"], let body = content["body"] else { return }
        
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = UNNotificationSound.default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerInterval, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }

    func triggerScheduledNotification() {
        
        // 1. Define actions
        let focusAction = UNNotificationAction(
            identifier: "FOCUS_ACTION",
            title: "Focus",
            options: [.foreground]
        )
        
        let distractionAction = UNNotificationAction(
            identifier: "DISTRACTION_ACTION",
            title: "Distraction",
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
        
        
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "Hello World"
        content.sound = UNNotificationSound.default
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }

}
