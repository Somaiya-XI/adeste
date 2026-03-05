//
//  levelUpApp.swift
//  levelUp
//
//  Created by Somaiya on 16/08/1447 AH.
//

import SwiftUI
import SwiftData

@main
struct adesteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            Intention.self,
            Cycle.self,
        ])

        // Configure SwiftData to use the App Group container and ensure
        // the Library/Application Support directory exists before creating the store.
        let appGroupID = "group.adeste.app.local.mayar"
        let fileManager = FileManager.default

        guard let groupURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            fatalError("Could not resolve app group container URL for \(appGroupID)")
        }

        // <AppGroup>/Library/Application Support
        let libraryURL = groupURL.appendingPathComponent("Library", isDirectory: true)
        let appSupportURL = libraryURL.appendingPathComponent("Application Support", isDirectory: true)

        if !fileManager.fileExists(atPath: appSupportURL.path) {
            do {
                try fileManager.createDirectory(at: appSupportURL, withIntermediateDirectories: true)
            } catch {
                fatalError("Failed to create Application Support directory in app group: \(error)")
            }
        }

        let storeURL = appSupportURL.appendingPathComponent("LevelUpData.sqlite")
        let modelConfiguration = ModelConfiguration(schema: schema, url: storeURL)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)

    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationDelegate = NotificationDelegate()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}
