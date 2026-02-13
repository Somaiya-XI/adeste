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

// MARK: - View Extensions for Frame Sizes
extension View {
    func smallHabitFrame() -> some View {
        self.frame(width: 168, height: 128)
    }
    
    func wideHabitFrame() -> some View {
        self.frame(width: 345, height: 117.5)
    }
    
    func habitProgressCardFrame() -> some View {
        self.frame(width: 345, height: 243)
    }
    
    func waterCardFrame() -> some View {
        self.frame(width: 345, height: 117.5)
    }
}

struct AdaptiveHabitCard: View {
    let habit: HabitDisplayData
    let layoutType: HabitLayoutType
    let waterFilledBottles: Int?  // For water habit in large layout
    
    // Add this computed property
    private var shouldShowCheckmark: Bool {
        let titleLower = habit.title.lowercased()
        return titleLower.contains("athkar") ||
        titleLower.contains("prayer") ||
        titleLower.contains("wake up")
    }
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
    
    // MARK: - Reusable Components
    @ViewBuilder
    private var checkmarkOverlay: some View {
        Image(systemName: "checkmark.circle")
            .font(.s20Medium)
            .foregroundStyle(Color.white.opacity(0.7))
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    // MARK: - Small Layout (168x128)
    @ViewBuilder
    private var smallLayout: some View {
        let titleLower = habit.title.lowercased()
        
        // Custom small layout for Athkar (smaller icon)
        if titleLower.contains("athkar") {
            smallAthkarCard
        } else {
            smallGenericCard
        }
    }
    
    @ViewBuilder
    private var smallGenericCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .smallHabitFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.s12Medium)
                    .foregroundStyle(habit.textColorName?.lowercased() == "white" ? Color.white : Color(habit.textColorName ?? "white"))
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    if let value = habit.value {
                        Text(value)
                            .font(.s32Medium)
                            .foregroundStyle(habit.textColorName?.lowercased() == "white" ? Color.white : Color(habit.textColorName ?? "white"))
                    }
                    
                    if let unit = habit.unit {
                        Text(unit)
                            .font(.s12Light)
                            .foregroundStyle((habit.textColorName?.lowercased() == "white" ? Color.white : Color(habit.textColorName ?? "white")).opacity(0.7))
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
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
            .offset(x: 90, y: 67)
            
            // Conditional checkmark
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .smallHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - ATHKAR CARD | SMALL | FINAL | MILLIMETER-PERFECT OFFSETS (90, 55) | Title: .s12Medium | Value: .s20Medium | Icon: 70x70
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
            
            // Smaller icon (70x70 instead of 80x80)
            Image(systemName: habit.iconName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundStyle(Color.white.opacity(0.7))
                .offset(x: 90, y: 55)
            
            checkmarkOverlay
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
            wideGenericCard
        }
    }
    
    @ViewBuilder
    private var wideGenericCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .wideHabitFrame()
            
            VStack(alignment: .leading, spacing: 0) {
                Text(habit.title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.white)
                
                Spacer(minLength: 0)
                
                VStack(spacing: -6) {
                    Image(systemName: habit.iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(Color.white.opacity(0.7))
                    
                    if let subTitle = habit.subTitle {
                        Text(subTitle)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.white.opacity(0.7))
                            .textCase(.uppercase)
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 0)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - ATHKAR CARD | WIDE | FINAL | Title: .s20Medium | Subtitle: .s12Medium | Icon: 60x60 | Padding: 16px
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
                .frame(width: 60, height: 60)
                .foregroundStyle(Color.white.opacity(0.7))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            // Subtitle: Bottom-Center
            if let subTitle = habit.subTitle {
                Text(subTitle)
                    .font(.s12Medium)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .textCase(.uppercase)
                    .lineLimit(1)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - Custom Wide Card Variants (345x117.5)
    // MARK: - WAKE UP CARD | WIDE | FINAL | MILLIMETER-PERFECT OFFSETS (260, 35) | Title: .s20Medium | Value: .s32Medium | Icon: 90x90
    @ViewBuilder
    private var wideWakeUpCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .wideHabitFrame()
            
            // Title: Top-Leading corner
            Text(habit.title)
                .font(.s20Medium)
                .foregroundStyle(Color("brand-color"))
                .lineLimit(1)
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
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - EXERCISE CARD | WIDE | FINAL | MILLIMETER-PERFECT OFFSETS (260, 45) | Title: .s20Medium | Value: .system(28) | Icon: 60x60/70x70
    @ViewBuilder
    private var wideExerciseCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .wideHabitFrame()
            
            // Title: Top-Leading corner
            Text(habit.title)
                .font(.s20Medium)
                .foregroundStyle(Color.white)
                .lineLimit(1)
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
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .wideHabitFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - WATER CARD | WIDE | FINAL | MILLIMETER-PERFECT OFFSET (y: 10) | Title: .s20Medium | Bottles: .system(30) | Single Row Layout
    @ViewBuilder
    private var wideWaterCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .wideHabitFrame()
            
            // Title: Top-Leading corner (independent layer)
            Text(habit.title)
                .font(.s20Medium)
                .foregroundStyle(Color.white)
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Single row of 8 bottles - perfectly centered
            HStack(spacing: 4) {
                let filledCount = waterFilledBottles ?? (Int(habit.value ?? "0") ?? 0)
                ForEach(0..<8, id: \.self) { index in
                    Image(systemName: index < filledCount ? "waterbottle.fill" : "waterbottle")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(Color.white.opacity(0.7))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .offset(y: 10)
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
            
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
    // MARK: - WAKE UP CARD | LARGE | FINAL | MILLIMETER-PERFECT OFFSETS (210, 110) | Title: .s20Medium | Value: .system(36) | Icon: 150x150
    @ViewBuilder
    private var largeWakeUpCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
            // Title: Top-Leading corner
            Text(habit.title)
                .font(.s20Medium)
                .foregroundStyle(Color("brand-color"))
                .lineLimit(1)
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
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - EXERCISE CARD | LARGE | FINAL | MILLIMETER-PERFECT OFFSETS (235, 0) & (y: 30) | Title: .s20Medium | Value: .system(36) | Icon: 100x100
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
                
                // Icon: Centered and large
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
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
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
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - ATHKAR CARD | LARGE | FINAL | Title: .s20Medium | Subtitle: .s12Medium | Icon: 100x100 | Padding: 16px
    @ViewBuilder
    private var largeAthkarCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
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
                .frame(width: 100, height: 100)
                .foregroundStyle(Color.white.opacity(0.7))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            // Subtitle: Bottom-Center
            if let subTitle = habit.subTitle {
                Text(subTitle)
                    .font(.s20Medium)
                    .foregroundStyle(Color.white.opacity(0.7))
                    .textCase(.uppercase)
                    .lineLimit(1)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - WATER CARD | LARGE | FINAL | MILLIMETER-PERFECT OFFSET (y: 10) | Title: .s20Medium | Bottles: .system(55) | 2x4 Grid Layout
    @ViewBuilder
    private var largeWaterCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(habit.backgroundColorName))
                .habitProgressCardFrame()
            
            // Title: Top-Leading corner (independent layer)
            Text(habit.title)
                .font(.s20Medium)
                .foregroundStyle(Color.white)
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            // Two rows of 4 bottles each - perfectly centered
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    let filledCount = waterFilledBottles ?? (Int(habit.value ?? "0") ?? 0)
                    ForEach(0..<4, id: \.self) { index in
                        Image(systemName: index < filledCount ? "waterbottle.fill" : "waterbottle")
                            .font(.system(size: 55, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                }
                
                HStack(spacing: 8) {
                    let filledCount = waterFilledBottles ?? (Int(habit.value ?? "0") ?? 0)
                    ForEach(4..<8, id: \.self) { index in
                        Image(systemName: index < filledCount ? "waterbottle.fill" : "waterbottle")
                            .font(.system(size: 55, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.7))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .offset(y: 10)
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
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
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if shouldShowCheckmark {
                checkmarkOverlay
            }
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}









#Preview("Design System Catalog - All Habit Variants") {
    ScrollView {
        VStack(spacing: 48) {
            // MARK: - WAKE UP VARIANTS
            VStack(spacing: 16) {
                HStack {
                    Text("WAKE UP VARIANTS")
                        .font(.s16Semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                Divider()
                
                // Stack: Small -> Wide -> Large
                VStack(spacing: 16) {
                    AdaptiveHabitCard(
                        habit: HabitDisplayData(
                            title: "Wake up",
                            value: "7:45",
                            unit: "PM",
                            iconName: "sun.max",
                            isSystemIcon: true,
                            backgroundColorName: "sec-color-mustard",
                            textColorName: "brand-color"
                        ),
                        layoutType: .small
                    )
                    
                    AdaptiveHabitCard(
                        habit: HabitDisplayData(
                            title: "Wake up",
                            value: "7:45",
                            unit: "PM",
                            iconName: "sun.max",
                            isSystemIcon: true,
                            backgroundColorName: "sec-color-mustard",
                            textColorName: "brand-color"
                        ),
                        layoutType: .wide
                    )
                    
                    AdaptiveHabitCard(
                        habit: HabitDisplayData(
                            title: "Wake up",
                            value: "7:45",
                            unit: "PM",
                            iconName: "sun.max",
                            isSystemIcon: true,
                            backgroundColorName: "sec-color-mustard",
                            textColorName: "brand-color"
                        ),
                        layoutType: .large
                    )
                }
            }
            .padding(20)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // MARK: - WATER VARIANTS
            VStack(spacing: 16) {
                HStack {
                    Text("WATER VARIANTS")
                        .font(.s16Semibold)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                Divider()
                
                // Stack: Small -> Wide -> Large
                VStack(spacing: 16) {
                    AdaptiveHabitCard(
                        habit: HabitDisplayData(
                            title: "Water",
                            value: "5",
                            unit: "Bottles",
                            iconName: "waterbottle.fill",
                            backgroundColorName: "sec-color-blue",
                            textColorName: "white"
                        ),
                        layoutType: .small
                    )
                    
                    AdaptiveHabitCard(
                        habit: HabitDisplayData(
                            title: "Water intake",
                            value: "5",
                            iconName: "waterbottle.fill",
                            backgroundColorName: "sec-color-blue"
                        ),
                        layoutType: .wide,
                        waterFilledBottles: 5
                    )
                    
                    AdaptiveHabitCard(
                        habit: HabitDisplayData(
                            title: "Water intake",
                            value: "5",
                            iconName: "waterbottle.fill",
                            backgroundColorName: "sec-color-blue"
                        ),
                        layoutType: .large,
                        waterFilledBottles: 5
                    )
                }
            }
            .padding(20)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    .padding(.vertical, 20)
    .padding(.horizontal, 16)
    .background(Color(.systemGroupedBackground))
}

