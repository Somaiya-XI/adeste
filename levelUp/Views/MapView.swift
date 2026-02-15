//
//  MapView.swift
//  adeste
//
//  Created by Jory on 26/08/1447 AH.
//

import SwiftUI

struct MapView: View {
    let cycle: Cycle
    let currentDay: Int
    @Environment(\.dismiss) var dismiss
    
    // Colors matching your design
    private let beige = Color("base-shade-01")
    private let darkBrown = Color("brand-color")
    private let pink = Color("sec-color-pink")
    private let lightBeige = Color("base-shade-02")
    
    private let nodeSize: CGFloat = 80
    private let spacing: CGFloat = 60
    
    // Calculate total days from cycle
    private var totalDays: Int {
        switch cycle.cycleDuration {
        case .basic:
            return 7
        case .medium:
            return 14
        case .advanced:
            return 21
        }
    }
    
    var body: some View {
        
        ZStack {
            beige.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(darkBrown)
                            .frame(width: 50, height: 50)
                            .background(lightBeige)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("Day \(currentDay)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(darkBrown)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(pink)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Map ScrollView
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Star at the top
                            ZStack {
                                Star()
                                    .stroke(darkBrown, lineWidth: 3)
                                    .fill(Color(red: 0.93, green: 0.78, blue: 0.49))
                                    .frame(width: 100, height: 100)
                                
                                // Mascot at the star when cycle is complete
                                if currentDay >= totalDays {
                                    MascotView()
                                        .offset(y: -70)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                            
                            // Days nodes - ForEach loop creates boxes based on totalDays
                            ForEach((1...totalDays).reversed(), id: \.self) { day in
                                VStack(spacing: 0) {
                                    // Dashed line connector
                                    DashedLine()
                                        .stroke(darkBrown, style: StrokeStyle(lineWidth: 3, dash: [8, 8]))
                                        .frame(width: 3, height: spacing)
                                    
                                    // Day node
                                    ZStack {
                                        // Node background
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(day == currentDay ? pink : lightBeige)
                                            .frame(width: nodeSize, height: nodeSize)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(darkBrown, lineWidth: 3)
                                            )
                                        
                                        // Day number
                                        Text("\(day)")
                                            .font(.system(size: 36, weight: .bold))
                                            .foregroundColor(darkBrown)
                                        
                                        // Mascot on current day (if not completed)
                                        if day == currentDay && currentDay < totalDays {
                                            MascotView()
                                                .offset(y: -65)
                                                .transition(.scale.combined(with: .opacity))
                                        }
                                    }
                                    .id(day)
                                }
                            }
                            
                            // Final dashed line at the bottom
                            DashedLine()
                                .stroke(darkBrown, style: StrokeStyle(lineWidth: 3, dash: [8, 8]))
                                .frame(width: 3, height: 100)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                    .onAppear {
                        scrollToCurrentDay(proxy: proxy)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func scrollToCurrentDay(proxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeInOut(duration: 0.5)) {
                if currentDay >= totalDays {
                    proxy.scrollTo(totalDays, anchor: .top)
                } else {
                    proxy.scrollTo(currentDay, anchor: .center)
                }
            }
        }
    }
}

// MARK: - Mascot View Component
struct MascotView: View {
    @State private var isAnimating = false
    
    var body: some View {
        Image("im_mc") // Your mascot from assets
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(
                Animation.easeInOut(duration: 0.8)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

// MARK: - Star Shape
struct Star: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.4
        let numberOfPoints = 5
        
        for i in 0..<numberOfPoints * 2 {
            let angle = (Double(i) * .pi) / Double(numberOfPoints) - .pi / 2
            let radius = i.isMultiple(of: 2) ? outerRadius : innerRadius
            let x = center.x + CGFloat(cos(angle)) * radius
            let y = center.y + CGFloat(sin(angle)) * radius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Dashed Line Shape
struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        return path
    }
}

// MARK: - Preview
#Preview {
    let cycle = Cycle(id: "1", cycleType: .Basic, cycleDuration: .basic)
    return NavigationStack {
        MapView(cycle: cycle, currentDay: 5)
    }
}
