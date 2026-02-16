//
//  ProfileView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("userName") private var userName: String = "My Name"
    @State private var showNameEditor = false
    @State private var showSettings = false
    @State private var achievements: [String] = []
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                Text(consts.profilepageStr)
                    .font(.s32Bold)
                    .foregroundStyle(Color("brand-color"))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(height: 20)

                VStack(alignment: .center) {
                    Image("im_mc")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(5)
                        .background(Color("base-shade-01"))
                        .clipShape(Circle())

                    Button {
                        showNameEditor = true
                    } label: {
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)
                            HStack(spacing: 6) {
                                Image(systemName: "pencil.line")
                                    .font(.s14Medium)
                                    .foregroundStyle(Color("brand-color").opacity(0.5))
                                Text(userName)
                                    .font(.s24Medium)
                                    .foregroundStyle(Color("brand-color"))
                            }
                            Spacer(minLength: 0)
                        }
                    }
                    .buttonStyle(.plain)
                }

                Spacer().frame(height: 36)

                // Achievements
                NavigationLink(destination: AchievementsView()) {
                    HStack {
                        Text(consts.achievementsStr)
                            .font(.s24Medium)
                            .foregroundStyle(Color("brand-color"))
                        Spacer(minLength: 0)
                        Image("ic_chevron") 
                    }
                }
                .buttonStyle(.plain)
                .disabled(achievements.isEmpty)

                Spacer().frame(height: 16)

                if achievements.isEmpty{
                    VStack{
                        EmptyStateUI(sfSymbol: "heart.circle.fill",
                                     text: "Complete cycles to earn stamps", iconSize: 70)
                    }.frame(height: 140)
                   
                } else {
                    HStack(spacing: 24) {
                        ForEach(0..<3, id: \.self) { _ in
                            Circle()
                                .fill(Color("base-shade-01"))
                                .frame(width: 90, height: 90)
                        }
                    }
                }
                
 
                Spacer().frame(height: 36)

                // Settings
                Text(consts.settingsStr)
                    .font(.s24Medium)
                    .foregroundStyle(Color("brand-color"))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(height: 16)

                VStack(spacing: 0) {
                    NavigationLink(destination: CycleView()) {
                        settingsRow(title: consts.selectCycleStr)
                    }
                    .buttonStyle(.plain)
                    customDivider
                    
                    NavigationLink(destination: ManageIntentionsView()) {
                        settingsRow(title: consts.manageIntentionsStr)
                    }
                    .buttonStyle(.plain)
                    
                    customDivider
    
                    Button{ showSettings = true } label:
                    { settingsRow(title: consts.manageScreenActivitiesStr)}
                    .buttonStyle(.plain)
                }
                Spacer(minLength: 32)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.white)
        .sheet(isPresented: $showSettings) {
            ScreenTimeSettingsView()
                .padding(.horizontal, 16)
                .padding(.top, 40)
        }
        .overlay {
            // Edit Name
            if showNameEditor {
                ZStack {
                     Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showNameEditor = false
                        }
                    
                    // Popup
                    EditNamePopup(userName: $userName, isPresented: $showNameEditor)
                }
            }
        }
    }

    
    private func settingsRow(title: String) -> some View {
        HStack {
            Text(title)
                .font(.s20Medium)
                .foregroundStyle(Color("brand-color"))
            Spacer(minLength: 0)
            Image("ic_chevron")
        }
        .padding(.vertical, 16)
    }

    private var customDivider: some View {
        Divider()
            .overlay(Color("brand-color").opacity(0.3))
    }
}


#Preview {
    NavigationStack {
        ProfileView()
    }
}
