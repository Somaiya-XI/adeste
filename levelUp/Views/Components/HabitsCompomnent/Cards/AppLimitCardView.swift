//
//  AppLimitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct AppLimitCardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.baseShade01)
            .frame(height: 96)
            .overlay(
                VStack(spacing: 6) {
                    Text("Usage Card")
                        .font(.s12Medium)
                        .foregroundColor(.gray)

                    Text("Screen time / limits")
                        .font(.s10Medium)
                        .foregroundColor(.gray.opacity(0.7))
                }
            )
    }
}

#Preview {
    AppLimitCardView()
}
