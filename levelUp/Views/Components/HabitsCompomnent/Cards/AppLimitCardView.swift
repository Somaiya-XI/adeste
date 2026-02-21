//
//  AppLimitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI
import DeviceActivity
import FamilyControls

struct AppLimitCardView: View {
    @State private var activityManager = DeviceActivityManager()
    @State private var showSettings = false
    @State private var reportID = UUID() // Force refresh key
    
    var body: some View {
        VStack{ RoundedRectangle(cornerRadius: 20)
                .fill(Color.baseShade01)
                .frame(height: 96)
                .overlay(
                    VStack{
                        if activityManager.isMonitoring {
                            VStack (alignment: .center, spacing: 4){
                                DeviceActivityReport(
                                    activityManager.reportContext,
                                    filter: activityManager.reportFilter
                                )
                                .id(reportID) // Force re-render when ID changes
                                .frame(height: 50)
                                .font(.s32Bold)
                                .foregroundStyle(.brand)
                                
                                if let threshold = activityManager.getThreshold() {
                                    Text(threshold.hours != 0 ? "Your limit is \(threshold.hours)h \(threshold.minutes)m" : "Your limit is \(threshold.minutes)m")
                                        .font(.s12Light)
                                        .foregroundColor(.brand)
                                }
                            }
                        } else {
                            Button { showSettings = true }
                            label: {
                                VStack(spacing: 4) {
                                    Text("--")
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundColor(.primary)
                                    Text("Tap to configure")
                                        .font(.s12Medium)
                                        .foregroundColor(.gray.opacity(0.7))
                                }
                            }.buttonStyle(.plain)
                            
                        }
                    }.padding(.horizontal, 16)
                    
                )
        }.sheet(isPresented: $showSettings) {
            ScreenTimeSettingsView()
                .padding(.horizontal, 16)
                .padding(.top, 40)
        }
        .onAppear {
            refreshReport()
        }
        .onChange(of: showSettings) { _, isPresented in
            // Refresh when settings sheet closes
            if !isPresented {
                refreshReport()
            }
        }
    }
    
    private func refreshReport() {
        // Reload selection and reconfigure filter
        activityManager.selectedActivities = DeviceActivityManager.loadSelection() ?? FamilyActivitySelection()
        activityManager.configureReportFilter()
        // Generate new ID to force DeviceActivityReport to re-fetch
        reportID = UUID()
    }
}

#Preview {
    AppLimitCardView()
}



