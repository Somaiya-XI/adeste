//
//  ProcessedDeviceActivityData.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings

struct ProcessedDeviceActivityData: Identifiable, Sendable {
    var id: UUID = UUID()
    
    // The user associated with the activity report.
    var user: DeviceActivityData.User
    
    // The device associated with the activity report.
    var device: DeviceActivityData.Device
    
    // The activity of the user divided into segments.
    var activitySegments: [ProcessedActivitySegment]
    
    // The segment interval of each DeviceActivityData.ActivitySegment in activitySegments.
    var segmentInterval: DeviceActivityFilter.SegmentInterval
    
    var lastUpdated: Date
    
    var totalDuration: TimeInterval {
        return self.activitySegments.reduce(0, {
            $0 + $1.totalActivityDuration
        })
    }    
}
