//
//  IntentionSummaryChart.swift
//  adeste
//
//  Created by Somaiya on 23/08/1447 AH.
//

import SwiftUI
import Charts

struct IntentionSummaryChart: View {
    var viewModel: IntentionsViewModel
    
    var data: [(type: String, amount: Double)] {
        let summary = viewModel.getIntentionsSummary()
        return [(type: "focus", amount: summary.totalFocus),
                (type: "distracted", amount: summary.totalDistraction)
        ]
    }
    var body: some View {
        let summary = viewModel.getIntentionsSummary()
        GeometryReader {
            let size = $0.size
            let w = size.width
            let h = size.height
        // Donut Chart using apple charts
        if summary.totalTriggeredIntentions == 0 {
            VStack {
                
                Image(systemName: consts.emptyIntentionChartIconStr)
                    .font(.system(size: h * 0.28))
                    .foregroundStyle(.secColorPink)
                    .opacity(0.5)
                
                Text(consts.emptyIntentionSummaryStr)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .font(.s16Medium)
                    
            }.frame(width: w, height: h * 0.7)
            
        } else {
            ZStack {
                Chart(data, id: \.type) { dataItem in
                    SectorMark(angle: .value("Type", dataItem.amount),
                               innerRadius: .ratio(0.88),
                               angularInset: 1.5)
                    .cornerRadius(5)
                    .foregroundStyle(dataItem.type == "focus" ? .secColorBerry : .secColorMustard)
                }
                .frame(height: h * 0.7)
                
                
                VStack() {
                    Text("\(Int(summary.focusPercentage))%")
                        .font(.s48Heavy)
                        .foregroundStyle(.brand)
                    
                    Text(consts.focusedStr)
                        .font(.s12Light)
                        .foregroundStyle(.brand)
                }
            }
        }
    }
    }
}

#Preview {
    
    IntentionSummaryChart(viewModel: IntentionsViewModel())
}
