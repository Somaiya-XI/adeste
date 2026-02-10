//
//  TabBar.swift
//  levelUp
//
//  Created by yumii on 10/02/2026.
//

import SwiftUI

// Tabs

enum Tab {
    case home
    case intentions
    case profile
}

// Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    var namespace: Namespace.ID

    struct TabItem: Identifiable {
        let id = UUID()
        let tab: Tab
        let title: String
        let icon: String
    }

    var items: [TabItem] = [
        .init(tab: .home,       title: consts.homepageStr,      icon: consts.homeTabIconStr),
        .init(tab: .intentions, title: consts.intentionpageStr, icon: consts.intentionsTabIconStr),
        .init(tab: .profile,    title: consts.profilepageStr,   icon: consts.profileTabIconStr)
    ]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(items) { item in
                tabButton(for: item)
            }
        }
        .padding(4)
        .frame(width: 296, height: 60)
        .background(Color("base-shade-01"))
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }

    @ViewBuilder
    func tabButton(for item: TabItem) -> some View {
        let isSelected = selectedTab == item.tab

        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                selectedTab = item.tab
            }
        } label: {
            ZStack {
                if isSelected {
                    Capsule()
                        .fill(Color("base-shade-03"))
                        .matchedGeometryEffect(id: "tabBackground", in: namespace)
                }

                VStack(spacing: 4) {
                    Image(systemName: item.icon)
                        .font(.system(size: 20, weight: .semibold))

                    Text(item.title)
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundStyle(
                    isSelected
                    ? Color("brand-color")
                    : Color("base-shade-02")
                )
                .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.plain)
    }
}

