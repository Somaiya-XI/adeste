//
//  ActivityReport.swift
//  ActivityReport
//
//  Created by Somaiya on 27/08/1447 AH.
//

import DeviceActivity
import ExtensionKit
import SwiftUI

@main
struct ActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        RawDataReport { data in
            RawDataReportView(data: data)
        }
        GraphReport { data in
            GraphReportView(graphData: data)
        }
        UserCategoryReport { usageData in
            UserCategoryReportView(usageData: usageData)
        }
    }
}
