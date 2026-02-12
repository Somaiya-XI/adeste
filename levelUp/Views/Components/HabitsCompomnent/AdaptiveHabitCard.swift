//
//  AdaptiveHabitCard.swift
//  levelUp
//
//  Adaptive habit card that supports .small, .wide, and .large layouts for all habit types.
//

import SwiftUI

enum HabitLayoutType {
    case small   // 168x128 (SmallHabitCard)
    case wide    // 345x117.5 (WideHabitCard)
    case large   // 345x243 (HabitProgressCard; Water defaults to wide)
}

struct AdaptiveHabitCard: View {
    let habit: HabitDisplayData
    let layoutType: HabitLayoutType
    let waterFilledBottles: Int?  // For water habit in large layout
    
    init(
        habit: HabitDisplayData,
        layoutType: HabitLayoutType,
        waterFilledBottles: Int? = nil
    ) {
        self.habit = habit
        self.layoutType = layoutType
        self.waterFilledBottles = waterFilledBottles
    }
    
    var body: some View {
        switch layoutType {
        case .small:
            smallLayout
        case .wide:
            wideLayout
        case .large:
            largeLayout
        }
    }
    
    // MARK: - Small Layout (168x128)
    @ViewBuilder
    private var smallLayout: some View {
        let titleLower = habit.title.lowercased()
        
        // Custom small layout for Athkar (smaller icon)
        if titleLower.contains("athkar") {
            smallAthkarCard
        } else {
            ZStack(alignment: .topTrailing) {
                SmallHabitCard(
                    title: habit.title,
                    value: habit.value ?? "",
                    unit: habit.unit,
                    iconName: habit.iconName,
                    isSystemIcon: habit.isSystemIcon,
                    backgroundColorName: habit.backgroundColorName,
                    textColorName: habit.textColorName ?? "white"
                )
                
                // Completion checkmark
                Image(systemName: "checkmark.circle")
                    .font(.s20Medium)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .padding(8)
            }
        }
    }
    
    @ViewBuilder
    private var smallAthkarCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .smallHabitFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s12Medium)
                    .foregroundStyle(habit.textColorName?.lowercased() == "white" ? Color.white : Color(habit.textColorName ?? "white"))
                
                if let value = habit.value {
                    Text(value)
                        .font(.s20Medium)
                        .foregroundStyle(habit.textColorName?.lowercased() == "white" ? Color.white : Color(habit.textColorName ?? "white"))
                }
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Smaller icon (64x64 instead of 80x80)
            Image(systemName: habit.iconName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundStyle(Color.white.opacity(0.7))
                .offset(x: 90, y: 55)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .smallHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Wide Layout (345x117.5)
    @ViewBuilder
    private var wideLayout: some View {
        let titleLower = habit.title.lowercased()
        
        // Custom wide layouts for specific habits
        if titleLower.contains("wake") || titleLower.contains("wake up") {
            wideWakeUpCard
        } else if titleLower.contains("exercise") || titleLower.contains("steps") {
            wideExerciseCard
        } else if titleLower.contains("water") || habit.iconName.contains("water") {
            wideWaterCard
        } else if titleLower.contains("athkar") {
            wideAthkarCard
        } else {
            ZStack(alignment: .topTrailing) {
                WideHabitCard(
                    title: habit.title,
                    subTitle: habit.subTitle ?? "Daily",
                    iconName: habit.iconName,
                    backgroundColorName: habit.backgroundColorName
                )
                
                // Completion checkmark
                Image(systemName: "checkmark.circle")
                    .font(.s20Medium)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .padding(8)
            }
        }
    }
    
    @ViewBuilder
    private var wideAthkarCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .wideHabitFrame()
            
            // Title: Top-Leading corner
            Text(habit.title)
                .font(.s20Medium)
                .foregroundStyle(Color.white)
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Icon: Centered and large
            Image(systemName: habit.iconName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundStyle(Color.white.opacity(0.7))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            // Subtitle: Bottom-Center
            if let subTitle = habit.subTitle {
                Text(subTitle)
                    .font(.s12Medium)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .textCase(.uppercase)
                    .lineLimit(1)
                    .padding(.bottom, 12)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Custom Wide Card Variants (345x117.5)
    @ViewBuilder
    private var wideWakeUpCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .wideHabitFrame()
            
            // Title: Top-Leading corner
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color("brand-color"))
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Time: Center of card
            if let value = habit.value {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.s32Medium)
                        .foregroundStyle(Color("brand-color"))
                    
                    if let unit = habit.unit {
                        Text(unit)
                            .font(.s12Light)
                            .foregroundStyle(Color("brand-color").opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Icon: Bottom-Trailing corner
            Image(systemName: habit.iconName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundStyle(Color.white.opacity(0.7))
                .offset(x: 260, y: 35)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var wideExerciseCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .wideHabitFrame()
            
            // Title: Top-Leading corner
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Steps: Center of card
            if let value = habit.value {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color.white)
                    
                    if let unit = habit.unit {
                        Text(unit)
                            .font(.s12Light)
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Icon: Bottom-Trailing corner
            Group {
                if habit.isSystemIcon {
                    Image(systemName: habit.iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                } else {
                    Image(habit.iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                }
            }
            .foregroundStyle(Color.white.opacity(0.7))
            .offset(x: 260, y: 45)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var wideWaterCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .wideHabitFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                // Two rows of 4 bottles each
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        let filledCount = waterFilledBottles ?? (Int(habit.value ?? "0") ?? 0)
                        ForEach(0..<4, id: \.self) { index in
                            Image(systemName: index < filledCount ? "waterbottle.fill" : "waterbottle")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                    }
                    
                    HStack(spacing: 4) {
                        let filledCount = waterFilledBottles ?? (Int(habit.value ?? "0") ?? 0)
                        ForEach(4..<8, id: \.self) { index in
                            Image(systemName: index < filledCount ? "waterbottle.fill" : "waterbottle")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Large Layout (345x243)
    @ViewBuilder
    private var largeLayout: some View {
        // Special case: Water habit has custom large layout
        let titleLower = habit.title.lowercased()
        
        if titleLower.contains("water") || habit.iconName.contains("water") {
            largeWaterCard
        } else if titleLower.contains("wake") || titleLower.contains("wake up") {
            largeWakeUpCard
        } else if titleLower.contains("exercise") || titleLower.contains("steps") {
            largeExerciseCard
        } else if titleLower.contains("pray") || titleLower.contains("praying") {
            largePrayerCard
        } else if titleLower.contains("athkar") {
            largeAthkarCard
        } else {
            largeGenericCard
        }
    }
    
    // MARK: - Large Card Variants (345x243)
    @ViewBuilder
    private var largeWakeUpCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
            // Title: Top-Leading corner
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color("brand-color"))
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Time: Perfectly centered (both horizontally and vertically)
            if let value = habit.value {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 36, weight: .medium, design: .rounded))
                        .foregroundStyle(Color("brand-color"))
                    
                    if let unit = habit.unit {
                        Text(unit)
                            .font(.s12Light)
                            .foregroundStyle(Color("brand-color").opacity(0.7))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Icon: Bottom-Trailing corner
            Image(systemName: habit.iconName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundStyle(Color.white.opacity(0.7))
                .offset(x: 210, y: 110)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var largeExerciseCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                // Title: Top-Leading corner
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                
                Spacer()
                
                // Icon: Centered and large
                if let value = habit.value {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(value)
                            .font(.system(size: 36, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white)
                        
                        if let unit = habit.unit {
                            Text(unit)
                                .font(.s12Light)
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .offset(y: 30)
                }
                
                Spacer()
                
                // Steps: Bottom-center
               
                
                Group {
                    if habit.isSystemIcon {
                        Image(systemName: habit.iconName)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    } else {
                        Image(habit.iconName)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                .foregroundStyle(Color.white.opacity(0.7))
                .offset(x: 235, y: 0)
                
                
         
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var largePrayerCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color.white)

                Spacer()
                
                Image(systemName: habit.iconName)
                    .font(.s80Regular)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                if let subTitle = habit.subTitle {
                    Text(subTitle)
                        .font(.s24Semibold)
                        .foregroundStyle(Color.white.opacity(0.7))
                        .textCase(.uppercase)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var largeAthkarCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color.white)

                Spacer()
                
                Image(systemName: habit.iconName)
                    .font(.s80Regular)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                if let subTitle = habit.subTitle {
                    Text(subTitle)
                        .font(.s20Medium)
                        .foregroundStyle(Color.white.opacity(0.7))
                        .textCase(.uppercase)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var largeWaterCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color.white)
                
                Spacer()
                
                // Two rows of 4 bottles each
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        let filledCount = waterFilledBottles ?? (Int(habit.value ?? "0") ?? 0)
                        ForEach(0..<4, id: \.self) { index in
                            Image(systemName: index < filledCount ? "waterbottle.fill" : "waterbottle")
                                .font(.system(size: 44, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                    }
                    
                    HStack(spacing: 8) {
                        let filledCount = waterFilledBottles ?? (Int(habit.value ?? "0") ?? 0)
                        ForEach(4..<8, id: \.self) { index in
                            Image(systemName: index < filledCount ? "waterbottle.fill" : "waterbottle")
                                .font(.system(size: 44, weight: .medium))
                                .foregroundStyle(Color.white.opacity(0.7))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                Text("Water intake")
                    .font(.s16Medium)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Completion checkmark
            Image(systemName: "checkmark.circle")
                .font(.s20Medium)
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    @ViewBuilder
    private var largeGenericCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(habit.title)
                    .font(.s20Medium)
                    .foregroundStyle(Color.white.opacity(0.7))

                Spacer()
                
                VStack(spacing: 8) {
                    Group {
                        if habit.isSystemIcon {
                            Image(systemName: habit.iconName)
                                .font(.s80Regular)
                        } else {
                            Image(habit.iconName)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        }
                    }
                    .foregroundStyle(Color.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Design System Catalog - All Habit Variants") {
    ScrollView {
        //        VStack(spacing: 48) {
        //            // MARK: - WAKE UP VARIANTS
        //            VStack(spacing: 16) {
        //                HStack {
        //                    Text("WAKE UP VARIANTS")
        //                        .font(.s16Semibold)
        //                        .foregroundStyle(.secondary)
        //                    Spacer()
        //                }
        //                Divider()
        //
        //                // Stack: Small -> Wide -> Large
        //                VStack(spacing: 16) {
        //                    AdaptiveHabitCard(
        //                        habit: HabitDisplayData(
        //                            title: "Wake up",
        //                            value: "7:45",
        //                            unit: "PM",
        //                            iconName: "sun.max",
        //                            isSystemIcon: true,
        //                            backgroundColorName: "sec-color-mustard",
        //                            textColorName: "brand-color"
        //                        ),
        //                        layoutType: .small
        //                    )
        //
        //                    AdaptiveHabitCard(
        //                        habit: HabitDisplayData(
        //                            title: "Wake up",
        //                            value: "7:45",
        //                            unit: "PM",
        //                            iconName: "sun.max",
        //                            isSystemIcon: true,
        //                            backgroundColorName: "sec-color-mustard",
        //                            textColorName: "brand-color"
        //                        ),
        //                        layoutType: .wide
        //                    )
        //
        //                    AdaptiveHabitCard(
        //                        habit: HabitDisplayData(
        //                            title: "Wake up",
        //                            value: "7:45",
        //                            unit: "PM",
        //                            iconName: "sun.max",
        //                            isSystemIcon: true,
        //                            backgroundColorName: "sec-color-mustard",
        //                            textColorName: "brand-color"
        //                        ),
        //                        layoutType: .large
        //                    )
        //                }
        //            }
        //            .padding(20)
        //            .background(Color(.systemBackground))
        //            .clipShape(RoundedRectangle(cornerRadius: 12))
        //        }
        //    }
        //}
        //
        //        // MARK: - EXERCISE VARIANTS
        //        VStack(spacing: 16) {
        //            HStack {
        //                Text("EXERCISE VARIANTS")
        //                    .font(.s16Semibold)
        //                    .foregroundStyle(.secondary)
        //                Spacer()
        //            }
        //            Divider()
        //
        //            // Stack: Small -> Wide -> Large
        //            VStack(spacing: 16) {
        //                AdaptiveHabitCard(
        //                    habit: HabitDisplayData(
        //                        title: "Exercise",
        //                        value: "9,565",
        //                        unit: "Steps",
        //                        iconName: "ic_steps",
        //                        isSystemIcon: false,
        //                        backgroundColorName: "sec-color-berry",
        //                        textColorName: "white"
        //                    ),
        //                    layoutType: .small
        //                )
        //
        //                AdaptiveHabitCard(
        //                    habit: HabitDisplayData(
        //                        title: "Exercise",
        //                        value: "9,565",
        //                        unit: "Steps",
        //                        iconName: "ic_steps",
        //                        isSystemIcon: false,
        //                        backgroundColorName: "sec-color-berry",
        //                        textColorName: "white"
        //                    ),
        //                    layoutType: .wide
        //                )
        //
        //                AdaptiveHabitCard(
        //                    habit: HabitDisplayData(
        //                        title: "Exercise",
        //                        value: "9,565",
        //                        unit: "Steps",
        //                        iconName: "ic_steps",
        //                        isSystemIcon: false,
        //                        backgroundColorName: "sec-color-berry",
        //                        textColorName: "white"
        //                    ),
        //                    layoutType: .large
        //                )
        //            }
        //        }
        //        .padding(20)
        //        .background(Color(.systemBackground))
        //        .clipShape(RoundedRectangle(cornerRadius: 12))
        
        //            // MARK: - PRAYER VARIANTS
        //            VStack(spacing: 16) {
        //                HStack {
        //                    Text("PRAYER VARIANTS")
        //                        .font(.s16Semibold)
        //                        .foregroundStyle(.secondary)
        //                    Spacer()
        //                }
        //                Divider()
        //
        //                // Stack: Small -> Wide -> Large
        //                VStack(spacing: 16) {
        //                    AdaptiveHabitCard(
        //                        habit: HabitDisplayData(
        //                            title: "Praying",
        //                            value: "FJR",
        //                            unit: "Prayer",
        //                            iconName: "sunrise.fill",
        //                            backgroundColorName: "sec-color-berry",
        //                            textColorName: "white"
        //                        ),
        //                        layoutType: .small
        //                    )
        //
        //                    AdaptiveHabitCard(
        //                        habit: HabitDisplayData(
        //                            title: "Praying",
        //                            subTitle: "FJR",
        //                            iconName: "sunrise.fill",
        //                            backgroundColorName: "sec-color-berry"
        //                        ),
        //                        layoutType: .wide
        //                    )
        //
        //                    AdaptiveHabitCard(
        //                        habit: HabitDisplayData(
        //                            title: "Praying",
        //                            subTitle: "FJR",
        //                            iconName: "sunrise.fill",
        //                            backgroundColorName: "sec-color-berry"
        //                        ),
        //                        layoutType: .large
        //                    )
        //                }
        //            }
        //            .padding(20)
        //            .background(Color(.systemBackground))
        //            .clipShape(RoundedRectangle(cornerRadius: 12))
        
        // MARK: - ATHKAR MORNING VARIANTS
        VStack(spacing: 16) {
            HStack {
                Text("ATHKAR MORNING VARIANTS")
                    .font(.s16Semibold)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            Divider()
            
            // Stack: Small -> Wide -> Large
            VStack(spacing: 16) {
                AdaptiveHabitCard(
                    habit: HabitDisplayData(
                        title: "Athkar",
                        value: "MORNING",
                        iconName: "cloud.sun.fill",
                        backgroundColorName: "sec-color-mustard",
                        textColorName: "brand-color"
                    ),
                    layoutType: .small
                )
                
                AdaptiveHabitCard(
                    habit: HabitDisplayData(
                        title: "Athkar",
                        subTitle: "MORNING",
                        iconName: "cloud.sun.fill",
                        backgroundColorName: "sec-color-mustard"
                    ),
                    layoutType: .wide
                )
                
                AdaptiveHabitCard(
                    habit: HabitDisplayData(
                        title: "Athkar",
                        subTitle: "MORNING",
                        iconName: "cloud.sun.fill",
                        backgroundColorName: "sec-color-mustard"
                    ),
                    layoutType: .large
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
//            // MARK: - ATHKAR EVENING VARIANTS
//            VStack(spacing: 16) {
//                HStack {
//                    Text("ATHKAR EVENING VARIANTS")
//                        .font(.s16Semibold)
//                        .foregroundStyle(.secondary)
//                    Spacer()
//                }
//                Divider()
//                
//                // Stack: Small -> Wide -> Large
//                VStack(spacing: 16) {
//                    AdaptiveHabitCard(
//                        habit: HabitDisplayData(
//                            title: "Athkar",
//                            value: "EVENING",
//                            iconName: "moon.stars.fill",
//                            backgroundColorName: "sec-color-mustard",
//                            textColorName: "brand-color"
//                        ),
//                        layoutType: .small
//                    )
//                    
//                    AdaptiveHabitCard(
//                        habit: HabitDisplayData(
//                            title: "Athkar",
//                            subTitle: "EVENING",
//                            iconName: "moon.stars.fill",
//                            backgroundColorName: "sec-color-mustard"
//                        ),
//                        layoutType: .wide
//                    )
//                    
//                    AdaptiveHabitCard(
//                        habit: HabitDisplayData(
//                            title: "Athkar",
//                            subTitle: "EVENING",
//                            iconName: "moon.stars.fill",
//                            backgroundColorName: "sec-color-mustard"
//                        ),
//                        layoutType: .large
//                    )
//                }
//            }
//            .padding(20)
//            .background(Color(.systemBackground))
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//            
//            // MARK: - WATER VARIANTS
//            VStack(spacing: 16) {
//                HStack {
//                    Text("WATER VARIANTS")
//                        .font(.s16Semibold)
//                        .foregroundStyle(.secondary)
//                    Spacer()
//                }
//                Divider()
//                
//                // Stack: Small -> Wide -> Large
//                VStack(spacing: 16) {
//                    AdaptiveHabitCard(
//                        habit: HabitDisplayData(
//                            title: "Water",
//                            value: "5",
//                            unit: "Bottles",
//                            iconName: "waterbottle.fill",
//                            backgroundColorName: "sec-color-blue",
//                            textColorName: "white"
//                        ),
//                        layoutType: .small
//                    )
//                    
//                    AdaptiveHabitCard(
//                        habit: HabitDisplayData(
//                            title: "Water intake",
//                            value: "5",
//                            iconName: "waterbottle.fill",
//                            backgroundColorName: "sec-color-blue"
//                        ),
//                        layoutType: .wide,
//                        waterFilledBottles: 5
//                    )
//                    
//                    AdaptiveHabitCard(
//                        habit: HabitDisplayData(
//                            title: "Water intake",
//                            value: "5",
//                            iconName: "waterbottle.fill",
//                            backgroundColorName: "sec-color-blue"
//                        ),
//                        layoutType: .large,
//                        waterFilledBottles: 5
//                    )
//                }
//            }
//            .padding(20)
//            .background(Color(.systemBackground))
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//        }
//        .padding(.vertical, 20)
//        .padding(.horizontal, 16)
//    }
//    .background(Color(.systemGroupedBackground))
//}
