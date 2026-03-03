//
//  PrivacyPolicyView.swift
//  adeste
//
//  Created by yumii on 02/03/2026.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Color.white.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Privacy Policy")
                                .font(.s32Bold)
                                .foregroundStyle(Color("brand-color"))
                            
                            Text("Last updated: March 2026")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        .padding(.top, 40)
                        
                        // Sections
                        policySection(
                            title: "1. Data Collection & Usage",
                            content: "Adeste request access to:\n• Apple Health (HealthKit): To track your daily steps for your exercise habit.\n• Screen Time API: To help you manage and limit your screen activities.\nWe only use this data to display your progress within the app."
                        )
                        
                        policySection(
                            title: "2. Local Storage Only",
                            content: "Your privacy is our priority. All your data is stored locally on your device. We do not use external servers, and we do not collect, read, or have access to your personal information."
                        )
                        
                        policySection(
                            title: "3. No Third-Party Sharing",
                            content: "Because your data never leaves your device, we do not sell, trade, or share your information with any third parties or advertisers."
                        )
                        
                        policySection(
                            title: "4. Contact Us",
                            content: "If you have any questions or concerns about your privacy, please reach out to us at support@adeste.com."
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 60)
                }
                
                // Close Button
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color("brand-color"))
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color("base-shade-01"))
                        )
                }
                .buttonStyle(.plain)
                .padding(.trailing, 24)
                .padding(.top, 24)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
    }
    
    // Custom Section Builder
    @ViewBuilder
    private func policySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.s20Medium)
                .foregroundStyle(Color("sec-color-pink"))
            
            Text(content)
                .font(.s16Regular)
                .foregroundStyle(.black)
                .lineSpacing(6)
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
