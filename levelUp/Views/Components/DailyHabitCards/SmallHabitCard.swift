//
//  SmallHabitCard.swift
//  levelUp
//
//  Created on 11/02/2026.
//

import SwiftUI

struct SmallHabitCard: View {
    let title: String
    let value: String
    let unit: String?
    let iconName: String
    let isSystemIcon: Bool
    let backgroundColorName: String
    let textColorName: String
    
    init(
        title: String,
        value: String,
        unit: String? = nil,
        iconName: String,
        isSystemIcon: Bool = true,
        backgroundColorName: String,
        textColorName: String
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.iconName = iconName
        self.isSystemIcon = isSystemIcon
        self.backgroundColorName = backgroundColorName
        self.textColorName = textColorName
    }
    
    private var textColor: Color {
        textColorName.lowercased() == "white" ? .white : Color(textColorName)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(backgroundColorName))
                .smallHabitFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.s12Medium)
                    .foregroundStyle(textColor)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.s32Medium)
                        .foregroundStyle(textColor)
                    
                    if let unit = unit {
                        Text(unit)
                            .font(.s12Light)
                            .foregroundStyle(textColor.opacity(0.7))
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
             Group {
                if isSystemIcon {
                    Image(systemName: iconName)
                        .font(.s80Regular)
                } else {
                    Image(iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
            }
            .foregroundStyle(Color.white.opacity(0.7))
            .offset(x: 90, y: 67)
        }
        .smallHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Wake Up Card") {
    SmallHabitCard(
        title: "Wake up",
        value: "7:45",
        unit: "PM",
        iconName: "sun.max",
        isSystemIcon: true,
        backgroundColorName: "sec-color-mustard",
        textColorName: "brand-color"
    )
    .padding()
}

#Preview("Exercise Card") {
    SmallHabitCard(
        title: "Exercise",
        value: "9,565",
        unit: "Steps",
        iconName: "ic_steps",
        isSystemIcon: false,
        backgroundColorName: "sec-color-berry",
        textColorName: "white"
    )
    .padding()
}
