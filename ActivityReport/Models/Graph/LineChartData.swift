//
//  LineChartData.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings


struct LineChartData: Identifiable {
    var id: UUID = UUID()
    var dateInterval: DateInterval
    var totalActivityDuration: TimeInterval
    
    var date: Date {
        return self.dateInterval.start
    }
    
}


extension ProcessedDeviceActivityData {
    var timeSeriesData: [LineChartData] {
        return self.activitySegments.map({LineChartData(dateInterval: $0.dateInterval, totalActivityDuration: $0.totalActivityDuration)}).sorted(by: {$0.date < $1.date})
    }
}
