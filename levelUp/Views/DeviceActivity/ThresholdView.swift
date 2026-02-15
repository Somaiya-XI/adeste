//
//  ThresholdView.swift
//  adeste
//
//  Created by Somaiya on 27/08/1447 AH.
//

import SwiftUI

struct ThresholdView: View {
    @Binding var thresholdTimeHour: Int
    @Binding var thresholdTimeMin: Int
    var body: some View {
            HStack{
                Text("Set a time limit")
                    .font(.s20Medium)
                Spacer()
                
            }.padding(.horizontal,16)
                .padding(.top, 16)
            .foregroundStyle(.secColorBerry)
            HStack {
                TimerDurationPicker(hour: $thresholdTimeHour, min: $thresholdTimeMin)
            }.foregroundStyle(.secColorBerry)
            .padding(.horizontal, 8)
    }
}

#Preview {
    @Previewable @State var h: Int = 4
    @Previewable @State var m: Int = 20
    ThresholdView(thresholdTimeHour: $h, thresholdTimeMin: $m)
}

