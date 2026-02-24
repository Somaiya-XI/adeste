//
//  RawDataReportView.swift
//  ReportExtension
//
//  Created by Itsuki on 2025/12/07.
//

import SwiftUI
import ManagedSettings
import DeviceActivity

struct RawDataReportView: View {
    
    let data: [ProcessedDeviceActivityData]
    
    var body: some View {
        List {
            var totalUsagePerUser: [DeviceActivityData.User : TimeInterval] {
                let grouped = Dictionary(grouping: data, by: {$0.user})
                return grouped.mapValues({$0.reduce(0, {
                        $0 + $1.totalDuration
                    })
                })
            }

            Section("Usage Per User") {
                if totalUsagePerUser.isEmpty {
                    NoDataAvailableText("No Per User Data Available...")
                }
                ForEach(Array(totalUsagePerUser.keys), id: \.appleID) { user in
                    if let totalDuration = totalUsagePerUser[user] {
                        HStack {
                            Text(user.name)
                            Spacer()
                            Text(totalDuration.formattedDuration)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            
            Section("Break Down") {
                if data.isEmpty {
                    NoDataAvailableText("No Break Down Data Available...")
                }
                ForEach(data) { data in
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(data.user.name) (\(data.device.name))")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if data.activitySegments.isEmpty {
                            NoDataAvailableText("No Activity Segments Available...")
                        }
                        
                        ForEach(data.activitySegments) { segment in
                            RawDataActivitySegmentView(segment: segment)
                        }
                    }
                }

            }

        }
        .contentMargins(.top, 8)

    }
}


struct RawDataActivitySegmentView: View {
    var segment: ProcessedActivitySegment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.segment.dateInterval.stringRepresentation)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    TwoColumnText(
                        String("Total Active Duration"),
                        self.segment.totalActivityDuration.formattedDuration
                    )
                }
                HStack {
                    TwoColumnText(
                        String("Total Pickups without activity"),
                        self.segment.totalPickupsWithoutApplicationActivity.formatted()
                    )
                }
                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Activity Per Category")
                        .fontWeight(.medium)

                    if self.segment.categories.isEmpty {
                        NoDataAvailableText("No Activity Categories Available")
                    }
                    ForEach(self.segment.categories) { category in
                        TwoColumnText(
                            String("- \(category.category.localizedDisplayName, default: "(Unknown)")"),
                            category.totalActivityDuration.formattedDuration
                        )
                    }
                })
            }
            .padding(.horizontal, 16)
            .font(.subheadline)
        }
    }
}


// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    List {
        RawDataActivitySegmentView(segment: .dummyData)
    }
}
