//
//  ActivitySegmentGraphData.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings


struct ActivitySegmentGraphData: Identifiable {
    var id: UUID = UUID()
    
    // The date interval of the activity segment.
    var dateInterval: DateInterval

    // The total activity during the activity segment.
    var totalActivityDuration: TimeInterval

    
    var pieChartData: [PieChartData]
}


extension ProcessedActivitySegment {
    var graphData: ActivitySegmentGraphData {
        return ActivitySegmentGraphData(
            dateInterval: self.dateInterval,
            totalActivityDuration: self.totalActivityDuration,
            pieChartData: self.categories.map(\.pieChartData)
        )
    }
}
