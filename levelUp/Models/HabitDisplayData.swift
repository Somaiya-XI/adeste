//
//  HabitDisplayData.swift
//  adeste
//
//  Created by Jory on 25/08/1447 AH.
//

//
//  HabitDisplayData.swift
//  levelUp
//
//  Data structure for displaying habits in AdaptiveHabitCard
//

import Foundation

struct HabitDisplayData {
    let title: String
    let value: String?
    let unit: String?
    let subTitle: String?
    let iconName: String
    let isSystemIcon: Bool
    let backgroundColorName: String
    let textColorName: String?
    
    init(
        title: String,
        value: String? = nil,
        unit: String? = nil,
        subTitle: String? = nil,
        iconName: String,
        isSystemIcon: Bool = true,
        backgroundColorName: String,
        textColorName: String? = "white"
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.subTitle = subTitle
        self.iconName = iconName
        self.isSystemIcon = isSystemIcon
        self.backgroundColorName = backgroundColorName
        self.textColorName = textColorName
    }
}
