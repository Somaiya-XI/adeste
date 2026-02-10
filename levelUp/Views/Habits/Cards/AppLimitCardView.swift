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
            .fill(Color.gray.opacity(0.15))
            .frame(height: 96)
            .overlay(
                VStack(spacing: 6) {
                    Text("Usage Card")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("Screen time / limits")
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.7))
                }
            )
    }
}

#Preview {
    AppLimitCardView()
}
