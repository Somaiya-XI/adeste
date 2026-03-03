//
//  Buttons.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI

/// Back button
struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(consts.chevronBack)
                .font(.s16Semibold)
                .foregroundStyle(Color("brand-color"))
                .frame(width: 40, height: 40)
                .background(Color("base-shade-02"))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}


/// Settings button
struct SettingsButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "gearshape.fill")
                .font(.s18Medium)
                .foregroundStyle(Color("brand-color"))
                .frame(width: 40, height: 40)
                .background(Color("base-shade-02"))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    BackButton(action: {})
    SettingsButton(action: {})
}

