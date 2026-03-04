//
//  SettingsView.swift
//  adeste
//
//  Created by yumii on 02/03/2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    @State private var showScreenTime = false
    @State private var showHabitGoals = false
    @State private var showPrivacyPolicy = false
    @State private var wakeUpTime = Date()
    @State private var stepGoal = 8000
    @State private var showChangeCycle = false
    @State private var showScreenTimeLimitAlert = false
    
    private let appLink = URL(string: "https://apple.com")!
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                BackButton { dismiss() }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    Text(consts.settingsStr)
                        .font(.s32Bold)
                        .foregroundStyle(Color("brand-color"))
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                    
                    // 1. SECTION: PREFERENCES
                    settingsSection(title: "PREFERENCES") {
                        NavigationLink(destination: StartCycle()) {
                            settingsRow(title: "Change Cycle", icon: "arrow.triangle.2.circlepath")
                        }
                        .buttonStyle(.plain)
                        
                        customDivider
                        
                        Button {
                            if UserManager.shared.canChangeScreenTime {
                                showScreenTime = true
                            } else {
                                showScreenTimeLimitAlert = true
                            }
                        } label: {
                            settingsRow(
                                title: consts.manageScreenActivitiesStr,
                                icon: "hourglass",
                                trailingText: !UserManager.shared.canChangeScreenTime ? "Limit reached" : nil,
                                showChevron: UserManager.shared.canChangeScreenTime
                            )
                        }
                        .buttonStyle(.plain)
                        .opacity(UserManager.shared.canChangeScreenTime ? 1.0 : 0.5)
                        
                        customDivider
                        
                        Button {
                            showHabitGoals = true
                        } label: {
                            settingsRow(title: "Manage Habit Goals", icon: "target")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // 2. SECTION: SUPPORT
                    settingsSection(title: "SUPPORT") {
                        Button {
                            // TODO: Show Onboarding
                        } label: {
                            settingsRow(title: "How to use Adeste", icon: "questionmark.circle")
                        }
                        .buttonStyle(.plain)
                        
                        customDivider
                        
                        Button {
                            if let emailURL = URL(string: "mailto:support@levelup.com") {
                                openURL(emailURL)
                            }
                        } label: {
                            settingsRow(title: "Contact Us", icon: "envelope", trailingText: "support@adeste.com")
                        }
                        .buttonStyle(.plain)
                        
                        customDivider
                        
                        Button {
                            showPrivacyPolicy = true
                        } label: {
                            settingsRow(title: "Privacy Policy", icon: "hand.raised", showChevron: true)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // 3. SECTION: FEEDBACK
                    settingsSection(title: "FEEDBACK") {
                        ShareLink(item: appLink) {
                            settingsRow(title: "Share with a friend", icon: "square.and.arrow.up", showChevron: false)
                        }
                        .buttonStyle(.plain)
                        
                        customDivider
                        
                        Button {
                            // TODO: Add SKStoreReviewController logic
                        } label: {
                            settingsRow(title: "Rate us on App Store", icon: "star", showChevron: false)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // 4. FOOTER
                    VStack(spacing: 12) {
                        Image("im_mc")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                        
                        Text("\"Disconnect to reconnect\"")
                            .font(.s16Medium)
                            .foregroundStyle(Color("sec-color-pink"))
                            .italic()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.white.ignoresSafeArea())
        
        // 1. Screen Time ✅ only once, with onDismiss
        .sheet(isPresented: $showScreenTime, onDismiss: {
            UserManager.shared.incrementScreenTimeChangeCount()
        }) {
            ScreenTimeSettingsView()
                .padding(.horizontal, 16)
                .padding(.top, 40)
        }
        
        // 2. Habit Goals
        .sheet(isPresented: $showHabitGoals) {
            HabitsGoalSheet(
                selectedHabits: ["Wake Up", "Walk"],
                selectedWakeUpTime: $wakeUpTime,
                stepGoal: $stepGoal,
                isOnboarding: false,
                cycleType: .basic
            )
        }
        
        // 3. Privacy Policy
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
                
        // 5. Limit Alert
        .alert("Limit Reached", isPresented: $showScreenTimeLimitAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You've used all \(UserManager.shared.cycleType.screenTimeChangeLimit) screen time changes for your \(UserManager.shared.cycleType.displayName) cycle.")
        }
    }
    
    // ==========================================
    // MARK: - UI Helpers  ✅ inside the struct
    // ==========================================
    
    @ViewBuilder
    public func settingsSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color("brand-color"))
                .padding(.horizontal, 32)
                .textCase(.uppercase)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color("base-shade-01"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 16)
        }
    }
    
    public var customDivider: some View {
        Divider()
            .background(Color.gray.opacity(0.3))
            .padding(.leading, 56)
    }
    
    // 🛠️ دالة مبرمجة بذكاء عشان تقبل السهم أو النص بناءً على اللي تحتاجينه
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
            } else if showChevron {
                Image("ic_chevron")
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
}  // ✅ struct closes here, BEFORE the extension

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

#Preview {
    SettingsView()
}
