//
//  HabitProgressBar.swift
//  adeste
//
//  Created by yumii on 26/02/2026.
//

import SwiftUI

struct HabitProgressBar: View {
    @State private var progressManager = AppProgressManager.shared
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                
                let state = getCharacterState()
                let charSize: CGFloat = state.size
                let characterName = state.name
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color("sec-color-berry").opacity(0.12))
                        .frame(height: 16)
                    
                    Capsule()
                        .fill(Color("brand-color"))
                        .frame(width: totalWidth * progressManager.completionPercentage, height: 16)
                    
                    Image(characterName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: charSize, height: charSize)
                        .offset(x: (totalWidth - charSize) * progressManager.completionPercentage, y: -15)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progressManager.completionPercentage)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 90)
            
            Text("\(progressManager.completedCount)/\(progressManager.totalCount)")
                .font(.s12Medium)
                .foregroundStyle(Color("brand-color"))
                .padding(.trailing, 8)
                .offset(y: -24)
        }
        .padding(.horizontal)
    }
    
    /// Determines the correct asset name and size based on current progress percentage.
    private func getCharacterState() -> (name: String, size: CGFloat) {
        if progressManager.completionPercentage <= 0 {
            return ("Sleepy-expression", 100)
        } else if progressManager.completionPercentage >= 1.0 {
            return ("Fire-expression", 100)
        } else {
            return ("im_mc", 85)
        }
    }
}

// MARK: - Previews
#Preview("Zero Progress (Sleepy)") {
    let _ = {
        let manager = AppProgressManager.shared
        manager.totalCount = 3
        manager.completedCount = 0
        manager.completionPercentage = 0
    }()
    return HabitProgressBar().padding(.top, 100)
}

#Preview("Full Progress (Fire)") {
    let _ = {
        let manager = AppProgressManager.shared
        manager.totalCount = 3
        manager.completedCount = 3
        manager.completionPercentage = 1.0
    }()
    return HabitProgressBar().padding(.top, 100)
}
