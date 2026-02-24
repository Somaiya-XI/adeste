@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings

/// Simple data structure for the card view
struct UsageSummaryData: Sendable {
    var totalDuration: TimeInterval
    var formattedDuration: String
}

// Your extension should provide a scene for each context that your app supports.
struct UserCategoryReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .userCategory
    
    // Define the custom configuration and the resulting view for this report.
    let content: (UsageSummaryData) -> UserCategoryReportView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> UsageSummaryData {
        // Calculate total duration from SELECTED categories only (not total screen time)
        var totalDuration: TimeInterval = 0
        
        for await activityData in data {
            for await segment in activityData.activitySegments {
                // Sum up only the selected categories' durations
                for await category in segment.categories {
                    totalDuration += category.totalActivityDuration
                }
            }
        }
        
        // Format the duration
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropAll
        
        let formattedDuration = formatter.string(from: totalDuration) ?? "0m"
        
        return UsageSummaryData(
            totalDuration: totalDuration,
            formattedDuration: formattedDuration
        )
    }
}
