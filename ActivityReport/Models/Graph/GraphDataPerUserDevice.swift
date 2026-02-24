//
//  GraphDataPerUserDevice.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//


@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings

struct GraphDataPerUserDevice: Identifiable {
    var id: UUID = UUID()
    // The user associated with the activity report.
    var user: DeviceActivityData.User
    
    // The device associated with the activity report.
    var device: DeviceActivityData.Device

    var timeSeriesData: [LineChartData]
    
    var activitySegmentsData: [ActivitySegmentGraphData]

}


extension ProcessedDeviceActivityData {
    var graphData: GraphDataPerUserDevice {
        return GraphDataPerUserDevice(user: self.user, device: self.device, timeSeriesData: self.timeSeriesData, activitySegmentsData: self.activitySegments.map(\.graphData))
    }
}
