//
//  TotalActivityReport.swift
//  ReportExtension
//
//  Created by Itsuki on 2025/12/07.
//

@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings


// Your extension should provide a scene for each context that your app supports.
struct RawDataReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .data
    
    // Define the custom configuration and the resulting view for this report.
    let content: ([ProcessedDeviceActivityData]) -> RawDataReportView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [ProcessedDeviceActivityData] {
        return await data.processedData
    }
}
