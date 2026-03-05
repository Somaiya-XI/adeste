//
//  OnboardingStepFourView.swift
//  levelUp
//
//  Reuses PickHabit habit data, selection logic, and icon mapping (HabitCardIconView).
//

import SwiftUI
import FamilyControls


struct OnboardingStepFiveView: View {
    @State private var selectedHabits: Set<String> = []
    @Environment(\.dismiss) var dismiss
    //
    @State private var showGoalSheet = false
    @State private var wakeUpTime: Date = Calendar.current.date(
        bySettingHour: 7, minute: 0, second: 0, of: Date()
    ) ?? Date()
    @State private var stepGoal: Int = 8000
    @State private var hasCompletedOnboarding = false
    @State var goToNext: Bool = false
    
    @State private var userManager = UserManager.shared
    @State var activityManager: DeviceActivityManager? = nil  // Lazy init
    @State var selectedApps = FamilyActivitySelection()
    @State var isPresented: Bool = false
    
    @State private var thresholdTimeMin: Int = 20
    @State private var thresholdTimeHour: Int = 4
    @State var showRequestAccess: Bool = true  // Default to true, set actual value in onAppear
    var body: some View {
        ZStack {
            Color("base-shade-01")
                .ignoresSafeArea()
            
            
            // Back Button
            GeometryReader{_ in
                Button { dismiss() }
                label:{ Image(.icBack) }
                    .padding(.top, 12)
                    .padding(.leading, 24)
            }
            
            VStack(spacing: 0) {
                
                // Header
                VStack(spacing: 10) {
                    Text("One Last Step")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.brand)
                    
                    Text(showRequestAccess ? "Allow access to screen time to set your screen time limit." : "Set a limit and track the apps that steal up your time.")
                        .font(.s18Medium)
                        .foregroundStyle(.brandGrey)
                }.multilineTextAlignment(.center)
                    .padding(.bottom, 32)
                
                if !showRequestAccess {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 16) {
                        Image(systemName: "hourglass.badge.lock")
                            .font(.system(size: 18))
                            .foregroundStyle(Color("brand-color"))
                            .frame(width: 24)
                        
                        Text("Set time limit")
                            .font(.s16Medium)
                            .foregroundStyle(Color("brand-color"))
                        
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    
                    
                    VStack{
                        ThresholdView(thresholdTimeHour: $thresholdTimeHour, thresholdTimeMin: $thresholdTimeMin)
                    }
                    .frame(height: 800 * 0.2)
                    .foregroundStyle(.secColorBerry)
                    
                    
                    
                    
                    Button {
                        isPresented = true
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: "lock.app.dashed")
                                .font(.system(size: 22))
                                .foregroundStyle(Color("brand-color"))
                                .frame(width: 24)
                                .padding(.bottom, 8)
                            VStack(alignment: .leading){
                                Text("Select apps to limit")
                                    .font(.s16Medium)
                                    .foregroundStyle(Color("brand-color"))
                                
                                Text(" ~\(selectedApps.applicationTokens.count + selectedApps.categoryTokens.count) selected \(selectedApps.applicationTokens.count + selectedApps.categoryTokens.count == 1 ? "activity": "activities") ")
                                    .font(.caption2)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.brandGrey)
                            }
                            Spacer()
                            
                            Image(.icChevron)
                                .foregroundStyle(.gray)
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .contentShape(Rectangle())
                        
                    }
                    .buttonStyle(.plain)
                    
                }
                .background(.baseShade03)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                if showRequestAccess {
                    VStack(alignment: .center, spacing: 12) {
                        
                        Image("screenTime")
                            .resizable()
                            .scaledToFit()
                        
                        Text("Allow Access to Screen Time")
                            .font(Font.s20Semibold)
                            .foregroundColor(.brandGrey)
                    }
                }
            
                Spacer()
                // Continue Button
                
                if showRequestAccess {
                    Button {
                        Task {
                            // Initialize manager if needed, then request authorization
                            if activityManager == nil {
                                activityManager = DeviceActivityManager()
                            }
                            await activityManager?.requestFamilyControlAuthorization()
                            showRequestAccess = AuthorizationCenter.shared.authorizationStatus != .approved
                        }
                    } label: {
                                Text("Allow screen time access")
                                    .font(.s18Semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(RoundedRectangle(cornerRadius: 32)
                                        .fill(.brand))
                            }
                }
                
                
                if !showRequestAccess {
                    Button {
                        do {
                            try activityManager?.startMonitoring(
                                    apps: selectedApps,
                                    thresholdHours: thresholdTimeHour,
                                    thresholdMinutes: thresholdTimeMin
                                )
                            } catch {
                                
                            }
                            
                        userManager.completeOnboarding()

                        
                    } label: {
                        Text("Ready")
                            .font(.s18Semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(RoundedRectangle(cornerRadius: 32)
                                .fill(.brand))
                    }
                }
               
                
                
            }.padding(.top, 68)
                .padding(.bottom, 26)
                .padding(.horizontal, 56)
        }.onAppear {
            // Check authorization status first (synchronous, fast)
            showRequestAccess = AuthorizationCenter.shared.authorizationStatus != .approved
            
      // Move all heavy work off the main thread during navigation
            Task { @MainActor in
                // Lazy initialize the DeviceActivityManager
                if activityManager == nil {
                    activityManager = DeviceActivityManager()
                }
                
                UserManager.shared.loadOnboardingState()
                
                if !userManager.isOnboardingComplete {
                    if activityManager?.isMonitoring == true {
                        activityManager?.stopMonitoring()
                    }
                }

                await activityManager?.requestFamilyControlAuthorization()
                showRequestAccess = AuthorizationCenter.shared.authorizationStatus != .approved
                
                // Load existing settings
                selectedApps = activityManager?.selectedActivities ?? FamilyActivitySelection()
                if let threshold = activityManager?.getThreshold() {
                    thresholdTimeHour = threshold.hours
                    thresholdTimeMin = threshold.minutes
                }
            }
        }
        .familyActivityPicker(isPresented: $isPresented, selection: $selectedApps)
            .navigationBarBackButtonHidden()
    }
    
    
}


#Preview {
    OnboardingStepFiveView()
}

