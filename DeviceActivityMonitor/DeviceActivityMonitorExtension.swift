//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor
//
//  Created by Somaiya on 27/08/1447 AH.
//

import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

// Shared constants - must match the main app
private enum Constants {
    static let appGroupID = "group.adeste.app"
    static let selectionKey = "adeste.screentime.selection"
    static let storeID = "adeste.screentime.store"
}

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    private let store = ManagedSettingsStore(named: .init(Constants.storeID))
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        print("📅 Interval started for \(activity.rawValue)")
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        removeShield()
        print("📅 Interval ended - shield removed")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        applyShield()
        print("⏰ Threshold reached - shield applied!")
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
    }
    
    // MARK: - Shield Management
    
    private func applyShield() {
        guard let selection = loadSelection() else {
            print("⚠️ No saved selection found in UserDefaults")
            return
        }
        
        store.shield.applications = selection.applicationTokens
        store.shield.applicationCategories = .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens
        
        print("✅ Shield applied to \(selection.applicationTokens.count) apps, \(selection.categoryTokens.count) categories")
    }
    
    private func removeShield() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
    }
    
    private func loadSelection() -> FamilyActivitySelection? {
        guard let defaults = UserDefaults(suiteName: Constants.appGroupID),
              let data = defaults.data(forKey: Constants.selectionKey) else {
            print("❌ Could not load data from UserDefaults with suite: \(Constants.appGroupID)")
            return nil
        }
        
        do {
            let selection = try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
            print("✅ Loaded selection with \(selection.applicationTokens.count) apps")
            return selection
        } catch {
            print("❌ Failed to decode selection: \(error)")
            return nil
        }
    }
}
