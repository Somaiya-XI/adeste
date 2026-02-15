//
//  GraphReportView.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/07.
//

import SwiftUI
import Charts
import ManagedSettings
import DeviceActivity

struct GraphReportView: View {
    
    let graphData: [GraphDataPerUserDevice]
    
    var body: some View {
        List {
            ForEach(graphData) { data in
                Section("\(data.user.name) (\(data.device.name))") {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Time Series")
                            .fontWeight(.medium)
                        
                        if data.timeSeriesData.isEmpty {
                            NoDataAvailableText("Time Series Data Not Available...")
                        } else {
                            Chart {
                                ForEach(data.timeSeriesData) { item in
                                    LineMark(
                                        x: .value("Date", item.date),
                                        y: .value("Profit B", item.totalActivityDuration),
                                    )
                                    .foregroundStyle(.green)
                                }
                            }
                            .chartXAxis(content: {
                                AxisMarks(values: .automatic) {
                                    AxisValueLabel(centered: true, anchor: .center)
                                    AxisGridLine()

                                }
                            })
                            .chartYAxis(content: {
                                AxisMarks(values: .automatic) { value in
                                    if let duration = value.as(TimeInterval.self) {
                                        AxisValueLabel {
                                            Text(duration.formattedDuration)
                                        }
                                        AxisGridLine()
                                    }
                                }
                            })
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Breakdown By Time Interval")
                            .fontWeight(.medium)
                        
                        if data.activitySegmentsData.isEmpty {
                            NoDataAvailableText("Break down Data Not Available...")
                        }
                        
                        ForEach(data.activitySegmentsData) { activitySegment in
                            GraphActivitySegmentView(segmentGraphData: activitySegment)
                        }
                        
                    }
                }
            }

        }
        .contentMargins(.top, 8)
    }
}


struct GraphActivitySegmentView: View {
    var segmentGraphData: ActivitySegmentGraphData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.segmentGraphData.dateInterval.stringRepresentation)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            VStack(alignment: .leading, spacing: 8) {

                
                VStack(alignment: .leading, spacing: 8, content: {
                    Text("Activity Per Category")
                        .fontWeight(.medium)

                    if self.segmentGraphData.pieChartData.isEmpty {
                        NoDataAvailableText("No Activity Categories Available")
                    } else {
                        Chart {
                            ForEach(self.segmentGraphData.pieChartData) { category in
                                SectorMark(angle: .value("", category.totalActivityDuration), outerRadius: 48)
                                    .foregroundStyle(by: .value("Category", category.category.localizedDisplayName ?? "(Unknown)"))
                                    
                            }
                        }
                        .frame(minHeight: 128)

                    }
                    
                })
                
                HStack {
                    TwoColumnText(
                        String("Total Active Duration"),
                        self.segmentGraphData.totalActivityDuration.formattedDuration
                    )
                }
            }
            .padding(.horizontal, 16)
            .font(.subheadline)
        }
    }
}
