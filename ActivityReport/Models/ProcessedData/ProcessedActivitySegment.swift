//
//  ProcessedActivitySegment.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//


@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings

struct ProcessedActivitySegment: Identifiable, Sendable {
    var id: UUID = UUID()
    
    // The user’s categorized device activity during the activity segment.
    var categories: [ProcessedCategoryActivity]
    
    // The date interval of the activity segment.
    var dateInterval: DateInterval
    
    // The first time the user picked up the device during the activity segment.
    var firstPickup: Date?
    
    // The date interval of the user’s longest activity session during the activity segment.
    var longestActivity: DateInterval?
    
    // The total activity during the activity segment.
    var totalActivityDuration: TimeInterval
    
    // The number of times the user picked up the device but did not use any applications.
    var totalPickupsWithoutApplicationActivity: Int
    
    @MainActor
    static let dummyData: ProcessedActivitySegment = ProcessedActivitySegment(categories: [], dateInterval: .init(start: Date().addingTimeInterval(-100), end: Date().addingTimeInterval(100)), totalActivityDuration: 100, totalPickupsWithoutApplicationActivity: 5)
}
