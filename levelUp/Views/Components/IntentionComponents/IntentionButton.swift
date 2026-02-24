//
//  IntentionButton.swift
//  adeste
//
//  Created by Somaiya on 23/08/1447 AH.
//

import SwiftUI

struct IntentionButton: View {
    var intention: Intention
    var viewModel: IntentionsViewModel
    
    var body: some View {
        
        Button{
            if !viewModel.isEditing {
                viewModel.currentIntention = intention
                viewModel.viewMode = .timer
                viewModel.triggerNotification(for: intention)
            } else {
                viewModel.currentlyEditing = intention
            }
        }
        label:{
            VStack(spacing: 4) {
                Image(systemName: intention.icon)
                    .font(.s24Medium)
                    .foregroundStyle(.brand)
                    .frame(width: 48, height: 48)
                    .background(.baseShade03)
                    .clipShape(Circle())

                Text(intention.title)
                    .font(.s16Medium)
                    .foregroundStyle(.brand)
            }
            .rotationEffect(.degrees(viewModel.isEditing ? 2 : -2))
            .offset(x: viewModel.isEditing ? 1 : -1)
            .animation(
                viewModel.isEditing
                ? .linear(duration: 0.12).repeatForever(autoreverses: true)
                : .default,
                value: viewModel.isEditing
            ).onLongPressGesture {
                if viewModel.viewMode == .main  {
                    viewModel.isEditing.toggle()
                }
            }
        }
        
    }
}

#Preview {
    IntentionButton(intention: Intention(title: "Texting", icon: consts.plusIcon),viewModel: IntentionsViewModel())
}
