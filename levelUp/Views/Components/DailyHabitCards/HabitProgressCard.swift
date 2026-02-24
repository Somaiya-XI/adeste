//
//  HabitProgressCard.swift
//  levelUp
//
//  Habit progress chart card for Page 3 of the Daily Habits carousel.
//

import SwiftUI

struct HabitProgressCard: View {
    /// Bar
    private static let barWidth: CGFloat = 10
    private static let barSpacing: CGFloat = 40
    private static let barCornerRadius: CGFloat = 2
    
    /// Mock data
    private let habits: [(systemIcon: String?, assetIcon: String?, progress: Double)] = [
        ("sun.max.fill", nil, 0.85),
        (nil, "ic_stepsprogress", 0.6),
        ("waterbottle.fill", nil, 0.4),
        ("sunrise.fill", nil, 0.9),
        ("cloud.sun.fill", nil, 0.7)
    ]
    
    private let targetLineRatio: Double = 0.5
    private let axisColor = Color("brand-color")
    private let barColor = Color.white.opacity(0.8)
    private let chartHeight: CGFloat = 140
    
    /// Width
    private var chartContentWidth: CGFloat {
        let n = CGFloat(habits.count)
        return n * Self.barWidth + (n - 0) * Self.barSpacing
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("sec-color-mustard"))
                .habitProgressCardFrame()
            
            VStack(alignment: .leading, spacing: 16) {
                 Text("Habit progress")
                    .font(.s20Medium)
                    .foregroundStyle(Color.white)
                
                /// Chart
                VStack(spacing: 8) {
                    /// Axes + target line + bars
                    ZStack(alignment: .bottom) {
                        /// L-shaped axes (brand-color)
                        Path { path in
                            let left: CGFloat = 0
                            let right = chartContentWidth
                            let bottom = chartHeight
                            path.move(to: CGPoint(x: left, y: 0))
                            path.addLine(to: CGPoint(x: left, y: bottom))
                            path.addLine(to: CGPoint(x: right, y: bottom))
                        }
                        .stroke(axisColor, lineWidth: 2)
                        
                        
                        /// Target line (dashed)
                        Path { path in
                            let y = chartHeight * (1 - CGFloat(targetLineRatio))
                            path.move(to: CGPoint(x: 0, y: y))
                            path.addLine(to: CGPoint(x: chartContentWidth, y: y))
                        }
                        .stroke(axisColor.opacity(0.8), style: StrokeStyle(lineWidth: 0.5, dash: [6, 3]))
                        
                        /// Bars
                        HStack(alignment: .bottom, spacing: Self.barSpacing) {
                            ForEach(0..<habits.count, id: \.self) { i in
                                RoundedRectangle(cornerRadius: Self.barCornerRadius)
                                    .fill(barColor)
                                    .frame(width: Self.barWidth, height: max(4, chartHeight * CGFloat(habits[i].progress)))
                            }
                        }
                    }
                    .frame(width: chartContentWidth, height: chartHeight)
                    
                    /// X-Axis icons
                    HStack(spacing: Self.barSpacing) {
                        ForEach(0..<habits.count, id: \.self) { i in
                            if let asset = habits[i].assetIcon {
                                Image(asset)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(axisColor)
                                    .frame(width: 16, height: 16)
                                    .frame(width: Self.barWidth, alignment: .center)
                            } else if let system = habits[i].systemIcon {
                                Image(systemName: system)
                                    .renderingMode(.template)
                                    .font(.s16Medium)
                                    .foregroundStyle(axisColor)
                                    .frame(width: 16, height: 16)
                                    .frame(width: Self.barWidth, alignment: .center)
                            }
                        }
                    }
                    .frame(width: chartContentWidth)
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 0)
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .habitProgressCardFrame()
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HabitProgressCard()
        .padding()
}
