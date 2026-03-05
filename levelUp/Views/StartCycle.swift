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
    @Environment(\.dismiss) var dismiss
    @Query(sort: [
        SortDescriptor(\Cycle.title),
    ]) var cycles: [Cycle]
    
    @State var vm: CycleViewModel = .init()
    @State var currentPage = 0
    @State var goToNext: Bool = false
    
    /// Tracks if user came from Settings (onboarding already complete)
    @State private var isChangingCycle = false
    
    /// Shows confirmation alert before resetting progress
    @State private var showResetConfirmation = false

    /// Cycles ordered by duration: 7 days (Light) → 14 (Balanced) → 21 (Deep)
    private var cyclesOrderedByDays: [Cycle] {
        cycles.sorted { $0.cycleDuration.rawValue < $1.cycleDuration.rawValue }
    }

    var body: some View {
        @Bindable var vm = vm
        GeometryReader{ _ in
            // Back button
            Button { dismiss() }
            label:{ Image(.icBack) }
            .padding(.top, 12)
            .padding(.leading, 24)
            
            
            VStack(spacing: 0) {
                // Top Logo Section
                VStack(spacing: 16) {
                    Text("Choose your cycle")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.brand)
                    
                    Text("Each cycle guides your habit detox.")
                        .font(.s18Medium)
                        .foregroundStyle(.brand)
                }.multilineTextAlignment(.center)
                
                Spacer()
                
                VStack(spacing: 24) {
                    ForEach(cyclesOrderedByDays) { cycle in
                        Button{
                            vm.currentCycle = cycle
                            vm.isCompleted = true
                        } label: {
                            CycleCard(cycle: cycle, isSelected: vm.currentCycle == cycle)
                        }
                    }
                }
                
                
                
                Spacer()
                // Continue Button
                Button {
                    if vm.currentCycle != nil {
                        if isChangingCycle {
                            // Show confirmation before resetting progress
                            showResetConfirmation = true
                        } else {
                            vm.isCompleted = true
                            goToNext = true
                        }
                    }
                } label: {
                    Text("Continue")
                        .font(.s18Semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(RoundedRectangle(cornerRadius: 32)
                            .fill(vm.currentCycle != nil ? .brand : .gray))
                }
                .disabled(vm.currentCycle == nil)
            }.padding(.top, 68)
                .padding(.bottom, 26)
                .padding(.horizontal, 56)
            
                .navigationDestination(isPresented: $goToNext) {
                    
                if let cycle = vm.currentCycle {
                    
                    if UserManager.shared.isOnboardingComplete {
                        OnboardingStepFourView(cycle: cycle)

                    } else {
                        OnboardingStepThreeView(cycle: cycle)
                        }
                    }
                }
                .onAppear {
                    vm.configure(with: modelContext)
                    UserManager.shared.loadOnboardingState()
                    // Capture if user is already onboarded (changing cycle from settings)
                    isChangingCycle = UserManager.shared.isOnboardingComplete
                }
                .onChange(of: goToNext) { oldValue, newValue in
                    // When returning from child view (goToNext false after being true)
                    // and we're changing cycle, dismiss back to Settings
                    if oldValue == true && newValue == false && isChangingCycle {
                        dismiss()
                    }
                }
        }.background(.baseShade01)
        .navigationBarBackButtonHidden(true)
        // Confirmation alert - warns before resetting progress
        .alert("Start a New Cycle?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Start Fresh", role: .destructive) {
                vm.isCompleted = true
                goToNext = true
            }
        } message: {
            Text("This will reset your current progress. You can’t undo this.")
        }
    }
    
}



// MARK: - CycleCard Component
struct CycleCard: View {
    var cycle: Cycle
    var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing:32) {
            
            HStack{
                Text("\(cycle.title) Cycle")
                    .padding(.leading, 8)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.brand)
                Spacer()
            }
            
            
            
            if isSelected {
                HStack(alignment: .top){
                    // Icons
                    VStack(alignment: .center){
                        
                        Image(systemName: "cloud.rainbow.crop")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(.secColorBerry)
                        
                        Image(systemName: "hourglass")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.secColorBerry)
                    }
                    
                    // Text
                    VStack(alignment: .leading){
                        Text("Build up to \(cycle.maxHabits) habits")
                            .font(.system(size: 18, weight: .light, design: .rounded))
                            .foregroundStyle(.brand)
                            .padding(.bottom, 1)
                        
                        
                        Text("\(cycle.cycleDuration.rawValue) days journey")
                            .font(.system(size: 18, weight: .light, design: .rounded))
                            .foregroundStyle(.brand)
                        
                    }.multilineTextAlignment(.center)
                }
                
            }
            
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 26)
        .background(.baseShade02)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? .brand : Color.clear, lineWidth: 2.5)
        )
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
    StartCycle()
        .modelContainer(previewContainer2)
    
}
