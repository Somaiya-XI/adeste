//
//  GraphReport.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/07.
//


@preconcurrency
import DeviceActivity
import ExtensionKit
import SwiftUI
import ManagedSettings


struct GraphReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .graph
    
    // Define the custom configuration and the resulting view for this report.
    let content: ([GraphDataPerUserDevice]) -> GraphReportView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> [GraphDataPerUserDevice] {
        print(#function)
        let data = await data.processedData
        return data.map(\.graphData)
    }
}
