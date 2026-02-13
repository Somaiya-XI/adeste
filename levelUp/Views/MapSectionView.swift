//  MapSectionView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI

struct MapSectionView: View {
    @State private var navigateToMap = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.baseShade01)
            .frame(height: 160)
            .overlay(
                VStack {
                    Button(action: {
                        navigateToMap = true
                    }) {
                        Image("Fire-expression") 
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        
                    }
                    Text("View Map")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            )
            .navigationDestination(isPresented: $navigateToMap) {
                MapView()
            }
    }
}

#Preview {
    NavigationStack {
        MapSectionView()
    }
}
