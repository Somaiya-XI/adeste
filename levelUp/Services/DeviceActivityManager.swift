//
//  DeviceActivityManager.swift
//  adeste
//
//  Created by Somaiya on 27/08/1447 AH.
//

import Foundation
import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

// MARK: - Shared Constants (used by both app and extension)
struct ScreenTimeConstants {
    static let appGroupID = "group.adeste.app"
    static let activityName = DeviceActivityName("adeste.screentime")
    static let eventName = DeviceActivityEvent.Name("adeste.screentime.event")
    static let selectionKey = "adeste.screentime.selection"
    static let storeID = "adeste.screentime.store"
}

@Observable
class DeviceActivityManager {
    var isMonitoring: Bool = false
    var selectedActivities: FamilyActivitySelection = FamilyActivitySelection()
    var reportContext: DeviceActivityReport.Context = .init("User Category")
    var reportFilter: DeviceActivityFilter = DeviceActivityFilter()
    
    private let managedSettingsStore = ManagedSettingsStore(named: .init(ScreenTimeConstants.storeID))
    private let deviceActivityCenter = DeviceActivityCenter()
    private let userDefaults = UserDefaults(suiteName: ScreenTimeConstants.appGroupID)!
    
    init() {
        isMonitoring = deviceActivityCenter.activities.contains(ScreenTimeConstants.activityName)
        selectedActivities = Self.loadSelection() ?? FamilyActivitySelection()
        configureReportFilter()
    }
    
    
    // MARK: - Report Filter Configuration
    func configureReportFilter() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: now) ?? now
        
        reportFilter = DeviceActivityFilter(
            segment: .daily(during: DateInterval(start: startOfDay, end: endOfDay)),
            users: .all,
            devices: .init([.iPhone]),
            applications: selectedActivities.applicationTokens,
            categories: selectedActivities.categoryTokens,
            webDomains: selectedActivities.webDomainTokens
        )
    }
    
    
    // MARK: - Static methods for extension access
    static func loadSelection() -> FamilyActivitySelection? {
        guard let defaults = UserDefaults(suiteName: ScreenTimeConstants.appGroupID),
              let data = defaults.data(forKey: ScreenTimeConstants.selectionKey),
              let selection = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data) else {
            return nil
        }
        return selection
    }
    
    static func applyShield() {
        guard let selection = loadSelection() else {
            return
        }
        let store = ManagedSettingsStore(named: .init(ScreenTimeConstants.storeID))
        store.shield.applications = selection.applicationTokens
        store.shield.applicationCategories = .specific(selection.categoryTokens)
        store.shield.webDomains = selection.webDomainTokens
    }
    
    static func removeShield() {
        let store = ManagedSettingsStore(named: .init(ScreenTimeConstants.storeID))
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        print("✅ Shield removed")
    }
    
    // MARK: - Instance methods for app
    func startMonitoring(apps: FamilyActivitySelection, thresholdHours: Int, thresholdMinutes: Int) throws {
        // Save selection for extension to access
        let data = try JSONEncoder().encode(apps)
        userDefaults.set(data, forKey: ScreenTimeConstants.selectionKey)
        userDefaults.synchronize()
        
        selectedActivities = apps
        configureReportFilter() // Update filter with new selection
        
        // Schedule: midnight to 23:59 daily
        var startComponents = DateComponents()
        startComponents.hour = 0
        startComponents.minute = 0
        
        var endComponents = DateComponents()
        endComponents.hour = 23
        endComponents.minute = 59
        
        let schedule = DeviceActivitySchedule(
            intervalStart: startComponents,
            intervalEnd: endComponents,
            repeats: true,
            warningTime: nil
        )
        
        // Threshold
        var threshold = DateComponents()
        threshold.hour = thresholdHours
        threshold.minute = thresholdMinutes
        
        let event = DeviceActivityEvent(
            applications: apps.applicationTokens,
            categories: apps.categoryTokens,
            webDomains: apps.webDomainTokens,
            threshold: threshold,
            includesPastActivity: true
        )
        
        // Stop existing monitoring first
        deviceActivityCenter.stopMonitoring([ScreenTimeConstants.activityName])
        
        try deviceActivityCenter.startMonitoring(
            ScreenTimeConstants.activityName,
            during: schedule,
            events: [ScreenTimeConstants.eventName: event]
        )
        
        isMonitoring = true
    }
    
    func stopMonitoring() {
        deviceActivityCenter.stopMonitoring([ScreenTimeConstants.activityName])
        Self.removeShield()
        userDefaults.removeObject(forKey: ScreenTimeConstants.selectionKey)
        isMonitoring = false
        selectedActivities = FamilyActivitySelection()
        configureReportFilter()
    }
    
    func getThreshold() -> (hours: Int, minutes: Int)? {
        let events = deviceActivityCenter.events(for: ScreenTimeConstants.activityName)
        guard let threshold = events[ScreenTimeConstants.eventName]?.threshold else { return nil }
        return (threshold.hour ?? 0, threshold.minute ?? 0)
    }
}

// MARK: - Permission
extension DeviceActivityManager {
    func requestFamilyControlAuthorization() async {
        let center = AuthorizationCenter.shared
        if center.authorizationStatus == .notDetermined {
            do {
                try await center.requestAuthorization(for: .individual)
            } catch {
                print("❌ Authorization failed: \(error)")
            }
        } else if center.authorizationStatus == .approved {
            print("✅ Family control approved")
        }
    }
}
