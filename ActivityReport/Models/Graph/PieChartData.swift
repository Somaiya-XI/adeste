//
//  PieChartData.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings

struct PieChartData: Identifiable {
    var id: UUID = UUID()
    var category: ActivityCategory
    var totalActivityDuration: TimeInterval
}

extension ProcessedCategoryActivity {
    var pieChartData: PieChartData {
        return PieChartData(category: self.category, totalActivityDuration: self.totalActivityDuration)
    }
}
