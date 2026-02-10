//
//  MapSectionView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct MapSectionView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.gray.opacity(0.15))
            .frame(height: 160)
            .overlay(
                VStack {
                    Text("Character / Time")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )
    }
}

#Preview {
    MapSectionView()
}
