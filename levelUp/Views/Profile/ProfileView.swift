//
//  ProfileView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                Text(consts.profilepageStr)
                    .font(.s32Medium)
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

                    Text("User Name")
                        .font(.s24Medium)
                        .foregroundStyle(Color("brand-color"))
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

                Spacer().frame(height: 16)

                HStack(spacing: 24) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle()
                            .fill(Color("base-shade-01"))
                            .frame(width: 90, height: 90)
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
                    settingsRow(title: consts.selectCycleStr)
                    customDivider
                    
                    NavigationLink(destination: ManageIntentionsView()) {
                        settingsRow(title: consts.manageIntentionsStr)
                    }
                    .buttonStyle(.plain)
                    
                    customDivider
    
                    settingsRow(title: consts.manageAccountStr)
                }

                Spacer(minLength: 32)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.white)
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
