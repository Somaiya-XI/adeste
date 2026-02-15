//
//  UserCategoryReportView.swift
//  ActivityReport
//
//  Created by Somaiya on 27/08/1447 AH.
//

import SwiftUI
import DeviceActivity

struct UserCategoryReportView: View {
    let usageData: UsageSummaryData
    
    var body: some View {
         Text(usageData.formattedDuration)
            .font(.s32Bold)
        .foregroundStyle(.brandGrey)
    }
}

#Preview {
    UserCategoryReportView(usageData: UsageSummaryData(
        totalDuration: 3600 * 2 + 45 * 60,
        formattedDuration: "2h 45m"
    ))
}
