//
//  EmptyStateUI.swift
//  ActivityReport
//
//  Created by Somaiya on 27/08/1447 AH.
//

import SwiftUI

struct EmptyStateUI: View {
    var sfSymbol: String
    var text: String
    var iconSize: CGFloat = 85
    var body: some View {
        GeometryReader{
            let size = $0.size
            let w = size.width
            
            VStack {
                
                Image(systemName: sfSymbol)
                    .font(.system(size: iconSize))
                    .foregroundStyle(.secColorPink)
                    .opacity(0.5)
                
                Text(text)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .font(.s16Medium)
                    .padding(.top, 2)
                    .padding(.horizontal, )
                    
            }.frame(width: w)
        }
    }
}

#Preview {
    EmptyStateUI(sfSymbol: "target", text: "Complete cycles to earn stamps")
}
