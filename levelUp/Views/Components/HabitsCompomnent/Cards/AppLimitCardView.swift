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
            // Refresh filter when view appears
            activityManager.configureReportFilter()
        }
        
    }
}

#Preview {
    AppLimitCardView()
}



