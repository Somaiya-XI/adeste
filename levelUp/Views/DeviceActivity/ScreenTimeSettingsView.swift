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
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Set your daily limit")
                        .foregroundStyle(.brand)
                        .font(.s24Medium)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 28)
                    
                    VStack{
                        ThresholdView(thresholdTimeHour: $thresholdTimeHour, thresholdTimeMin: $thresholdTimeMin)
                    }.frame(width: w * 0.88, height: h * 0.2)
                        .background(.baseShade01)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack{
                        Button {
                            isPresented = true
                        } label: {
                            HStack{
                                Text("Add activities to track")
                                    .font(.s20Medium)
                                Spacer()
                                Image(consts.chevronRight)
                            }.padding(16)
                                .foregroundStyle(.secColorBerry)
                        }
                        
                    }.frame(width: w * 0.88)
                        .background(.baseShade01)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Show selected apps count
                    if !selectedApps.applicationTokens.isEmpty || !selectedApps.categoryTokens.isEmpty {
                        Text("\(selectedApps.applicationTokens.count) apps, \(selectedApps.categoryTokens.count) categories selected")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack{
                        Button(activityManager.isMonitoring ? "Update" : "Start"){
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
                        }
                        .font(.s24Semibold)
                        .padding(16)
                        .foregroundStyle(.baseShade01)
                        
                    }
                    .frame(width: w * 0.88)
                    .background(.brand)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top, 28)
                    
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
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
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

#Preview {
    ScreenTimeSettingsView()
}
