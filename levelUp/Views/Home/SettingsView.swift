//
//  SettingsView.swift
//  adeste
//
//  Created by yumii on 02/03/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showScreenTime = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton { dismiss() }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(consts.settingsStr)
                        .font(.s32Bold)
                        .foregroundStyle(Color("brand-color"))
                        .padding(.top, 20)
                    
                    VStack(spacing: 0) {
                        NavigationLink(destination: CycleView()) {
                            settingsRow(title: consts.selectCycleStr)
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                            .overlay(Color("brand-color").opacity(0.3))
                        
                        Button {
                            showScreenTime = true
                        } label: {
                            settingsRow(title: consts.manageScreenActivitiesStr)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.white)
        .sheet(isPresented: $showScreenTime) {
            ScreenTimeSettingsView()
                .padding(.horizontal, 16)
                .padding(.top, 40)
        }
    }
    
    private func settingsRow(title: String) -> some View {
        HStack {
            Text(title)
                .font(.s20Medium)
                .foregroundStyle(Color("brand-color"))
            Spacer()
            Image("ic_chevron")
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    SettingsView()
}
