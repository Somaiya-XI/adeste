//
//  StartCycle.swift
//  levelUp
//
//  Created by Manar on 09/02/2026.
//

import SwiftUI
import SwiftData

struct StartCycle: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [
        SortDescriptor(\Cycle.title),
    ]) var cycles: [Cycle]
    
    @State var vm: CycleViewModel = .init()
    @State var currentPage = 0
    @State var goToNext: Bool = false
    
    let userName: String
    
    var body: some View {
        @Bindable var vm = vm
        VStack(spacing: 0) {
            // Top Logo Section
            Text("Find your flow")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.brandGrey)
                .padding(.bottom, 30)
            
            // Card Carousel
            VStack {
                
                // Main cards - Limits
                TabView(selection: $currentPage) {
                    ForEach(Array(cycles.enumerated()), id: \.element.id) { index, cycle in
                        CycleCard(cycle: cycle) {
                            vm.currentCycle = cycle
                            vm.isCompleted = true
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            // Page Indicator
            PageIndicator(numberOfPages: cycles.count, currentPage: currentPage)
                .padding(.top, 30)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToNext) {
            HabitPickerView(
                habitLimit: vm.currentCycle?.maxHabits ?? 2,
                userName: userName,
                cycleId: vm.currentCycle?.id ?? "",
                cycleType: vm.currentCycle?.cycleType ?? .starter
            )
        }
        .onAppear {
            vm.configure(with: modelContext)

        }
        .sheet(isPresented: $vm.isCompleted) {
            ScreenTimeSettingsView()
                .padding(.horizontal, 16)
                .padding(.top, 40)
                .onDisappear {
                    goToNext = true
                }
        }
    }
    
}


struct TopRoundedRectangle: Shape {
    var radius: CGFloat = 30

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let r = min(radius, rect.width / 2, rect.height / 2)
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
        path.addQuadCurve(to: CGPoint(x: rect.minX + r, y: rect.minY),
                          control: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + r),
                          control: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


// CycleCard Component
struct CycleCard: View {
    var cycle: Cycle

    let onGetStarted: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            ZStack(alignment: .center) {
                ZStack(alignment: .bottom){
                                            
                    // Header Section
                    HStack(alignment:.bottom) {
                        Spacer().frame(width: 100)
                        Text(cycle.title)
                            .padding(.leading, 8)
                            .font(.system(size: 24, weight: .heavy, design: .rounded))
                            .foregroundColor(.brand)
                        Spacer()

                    }.padding(.horizontal, 28)
                        .frame(height: 100)
                        .background(.baseShade02)
                        .clipShape(TopRoundedRectangle(radius: 24))

                    HStack{
                        Image(cycle.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 140)
                            .offset(x: -100)
                    }
                    
                }
            }
            // Content Section
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Know your cycle")
                        .font(.s24Medium)
                        .foregroundColor(.brandGrey)
                        .padding(.bottom, 8)

                    Text(cycle.desc)
                        .font(.system(size: 14, weight: .light, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.brandGrey.opacity(0.9))
                }
                .padding(.top, 24)
                .padding(.bottom, 32)

                HStack(alignment: .center, spacing: 4) {
                  Image(systemName: "cloud.rainbow.crop")
                        .symbolRenderingMode(.hierarchical)
                        .font(.system(size: 27, weight: .semibold))
                        .foregroundStyle(.secColorBerry)


                    Text("Build up to \(cycle.maxHabits) habits")
                        .font(.system(size: 16, weight: .heavy, design: .rounded))
                        .foregroundStyle(.secColorPink)
                    
                }.foregroundStyle(.secColorPink)

                
                VStack(alignment: .leading, spacing: 12) {
                    
                    
                }.padding(.bottom, 30)

                // Get Started Button
                Button {
                    onGetStarted()
                } label: {
                    Text("Get Started")
                        .font(.s18Semibold)
                        .foregroundColor(.brand)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .overlay{
                            RoundedRectangle(cornerRadius: 12) .stroke(Color(red: 0.35, green: 0.08, blue: 0.08), lineWidth: 2.5)
                        }
                }
                .padding(.bottom, 34)
            }
            .padding(.horizontal, 28)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color(red: 0.96, green: 0.91, blue: 0.84))
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 28)
    }
}

// FeatureRow Component
struct FeatureRow: View {
    let icon: String
    let iconColor: Color
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.s20Medium)
                .foregroundColor(iconColor)
                .frame(width: 28, height: 28)

            Text(text)
                .font(.s18Medium)
                .foregroundColor(iconColor)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - PageIndicator Component
struct PageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage
                          ? Color(red: 0.35, green: 0.08, blue: 0.08)
                          : Color.gray.opacity(0.25))
                    .frame(width: 8, height: 8)
                    .scaleEffect(index == currentPage ? 1.0 : 0.8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    StartCycle(userName: "Test")
        .modelContainer(previewContainer2)

}
