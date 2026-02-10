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
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundStyle(Color("brand-color"))
                .frame(width: 40, height: 40)
                .background(Color("base-shade-02").opacity(0.5))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}

struct Buttons: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    BackButton(action: {})
}

#Preview("Buttons") {
    Buttons()
}
