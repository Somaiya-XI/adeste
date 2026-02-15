//
//  DeviceActivityReportContext.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/07.
//

import SwiftUI
import DeviceActivity


// Context is only available when importing SwiftUI
extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let data = DeviceActivityReport.Context("Raw Data")
    static let graph = DeviceActivityReport.Context("Graph")

    
    static let allContext = [data, graph]
}
