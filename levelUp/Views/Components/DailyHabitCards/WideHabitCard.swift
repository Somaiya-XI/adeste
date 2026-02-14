//
//  WideHabitCard.swift
//  levelUp
//
//  Created on 12/02/2026.
//

import SwiftUI

struct WideHabitCard: View {
    let title: String
    let subTitle: String
    let iconName: String
    let backgroundColorName: String
    
    init(
        title: String,
        subTitle: String,
        iconName: String,
        backgroundColorName: String
    ) {
        self.title = title
        self.subTitle = subTitle
        self.iconName = iconName
        self.backgroundColorName = backgroundColorName
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(backgroundColorName))
                .wideHabitFrame()
            
            VStack(alignment: .leading, spacing: 0) {

                Text(title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.white)
                
                Spacer(minLength: 0)
                
                VStack(spacing: -6) {
                    Image(systemName: iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(Color.white.opacity(0.7))
                    
                    Text(subTitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.white.opacity(0.7))
                        .textCase(.uppercase)
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 0)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Page 2 symmetric grid (243px: 117.5 + 8 + 117.5)") {
    VStack(spacing: 8) {
        WideHabitCard(
            title: "Praying",
            subTitle: "FJR",
            iconName: "sunrise.fill",
            backgroundColorName: "sec-color-berry"
        )
        WideHabitCard(
            title: "Athkar",
            subTitle: "MORNING",
            iconName: "cloud.sun.fill",
            backgroundColorName: "sec-color-mustard"
        )
    }
    .padding()
}
