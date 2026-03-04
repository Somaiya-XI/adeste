//
//  ScreenTimeSettingsView.swift
//  levelUp
//
//  Created by yumii on 10/02/2026.
//

import SwiftUI
import SwiftData
import FamilyControls

struct ScreenTimeSettingsView: View {
    @State private var userManager = UserManager.shared
    @State var activityManager = DeviceActivityManager()
    @State var selectedApps = FamilyActivitySelection()
    @State var isPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var thresholdTimeMin: Int = 20
    @State private var thresholdTimeHour: Int = 4
    
    @State private var error: String?
    
    var body: some View {
        NavigationStack {
            GeometryReader {
                let size = $0.size
                let w = size.width
                let h = size.height
                
                VStack(spacing: 0) {
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("Set your daily screen limit")
                                .font(.system(size: 20, weight: .semibold))
                                .fontDesign(.rounded)
                                .foregroundStyle(Color("brand-color"))
                            
                            
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
                                    .frame(height: h * 0.2)
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
                                                
                                                Text(" ~\(activityManager.selectedActivities.applicationTokens.count + activityManager.selectedActivities.categoryTokens.count) selected \(activityManager.selectedActivities.applicationTokens.count + activityManager.selectedActivities.categoryTokens.count == 1 ? "activity": "activities") ")
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
                            .background(.baseShade01)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                    
                
                    Spacer()

                    
                    Button{
                            do {
                                try activityManager.startMonitoring(
                                    apps: selectedApps,
                                    thresholdHours: thresholdTimeHour,
                                    thresholdMinutes: thresholdTimeMin
                                )
                                dismiss()
                            } catch {
                                self.error = error.localizedDescription
                            }
                        } label: {
                            Text(activityManager.isMonitoring ? "Update" : "Start")
                                .font(.s18Semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background(RoundedRectangle(cornerRadius: 32)
                                        .fill(.brand))
                        }
                        
                   
                    
//                    if activityManager.isMonitoring {
//                        Button("Stop Monitoring") {
//                            activityManager.stopMonitoring()
//                        }
//                        .foregroundStyle(.red)
//                        .frame(maxWidth: .infinity)
//                        .padding(.top, 8)
//                    }
//                    
                    if let error = error {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                }.padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 26)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
                if !userManager.isOnboardingComplete {
                    if activityManager.isMonitoring {
                        activityManager.stopMonitoring()
                    }
                }

                Task {
                    await activityManager.requestFamilyControlAuthorization()
                }
                // Load existing settings
                selectedApps = activityManager.selectedActivities
                if let threshold = activityManager.getThreshold() {
                    thresholdTimeHour = threshold.hours
                    thresholdTimeMin = threshold.minutes
                }
            }
            .familyActivityPicker(isPresented: $isPresented, selection: $selectedApps)
        }
    }
}


public var customDivider: some View {
    Divider()
        .background(Color.gray.opacity(0.3))
        .padding(.leading, 56)
}

public func settingsRow(title: String, icon: String, trailingText: String? = nil, showChevron: Bool = true) -> some View {
    HStack(spacing: 16) {
        Image(systemName: icon)
            .font(.system(size: 18))
            .foregroundStyle(Color("brand-color"))
            .frame(width: 24)
        
        Text(title)
            .font(.s16Medium)
            .foregroundStyle(Color("brand-color"))
        
        Spacer()
        
        if let text = trailingText {
            Text(text)
                .font(.s14Medium)
                .foregroundStyle(Color("sec-color-pink"))
        }
        else if showChevron {
            Image("ic_chevron")
                .foregroundStyle(.gray)
        }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 16)
    .contentShape(Rectangle())
}

#Preview {
    ScreenTimeSettingsView()
}
