//
//  ActivityDetailView.swift
//  DeviceActivityMonitorDemo
//
//  Created by Itsuki on 2025/10/23.
//

import SwiftUI
import DeviceActivity
import FamilyControls

struct ActivityDetailView: View {
    @Environment(DeviceActivityManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("Status") {
                HStack {
                    Text("Monitoring")
                    Spacer()
                    Text(manager.isMonitoring ? "Active" : "Inactive")
                        .foregroundStyle(manager.isMonitoring ? .green : .secondary)
                }
                
                if let threshold = manager.getThreshold() {
                    HStack {
                        Text("Time Limit")
                        Spacer()
                        Text("\(threshold.hours)h \(threshold.minutes)m")
                    }
                }
            }
            
            Section("Selected Apps") {
                let selection = manager.selectedActivities
                if selection.applicationTokens.isEmpty && selection.categoryTokens.isEmpty {
                    Text("No apps selected")
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(selection.applicationTokens.count) apps")
                    Text("\(selection.categoryTokens.count) categories")
                }
            }
        }
        .navigationTitle("Screen Time")
        .navigationBarTitleDisplayMode(.large)
    }
}
