//
//  RawDataReportView.swift
//  ReportExtension
//
//  Created by Itsuki on 2025/12/07.
//

import SwiftUI
import ManagedSettings
import DeviceActivity

struct SelectedCategoriesReportView: View {
    
    let data: [ProcessedDeviceActivityData]
    
    var body: some View {
        ForEach(data) { data in
            ForEach(data.activitySegments) { segment in
                SelectedCategoriesActivitySegmentView(segment: segment)
            }
        }
    }
}


struct SelectedCategoriesActivitySegmentView: View {
    var segment: ProcessedActivitySegment
    
    var totalDuration: TimeInterval {
        segment.categories.reduce(0) { sum, category in
            sum + category.totalActivityDuration
        }
    }
    
    // Compute the total activities as the sum of category and application durations
    var totalSelectedActivities: TimeInterval {
        for category in segment.categories{
            return category.applications.reduce(0) { sum, application in
                sum + application.totalActivityDuration
            }
        }
        return 0
    }
    
    var body: some View {
        Text(totalDuration.formattedDuration)
    }
}


// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    List {
        SelectedCategoriesActivitySegmentView(segment: .dummyData)
    }
}

