//
//  ManageIntentionsView.swift
//  levelUp
//
//  Created by yumii on 10/02/2026.
//

import SwiftUI
import SwiftData

struct ManageIntentionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Intention.title) private var intentions: [Intention]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                     ZStack {
                        Text(consts.manageIntentionsStr)
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundStyle(Color("brand-color"))
                        
                        HStack {
                            BackButton(action: { dismiss() })
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(intentions) { intention in
                                intentionRow(intention: intention)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    @ViewBuilder
    private func intentionRow(intention: Intention) -> some View {
        HStack(spacing: 12) {
            // Left icon
            Image(systemName: intention.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color("brand-color"))
                .frame(width: 32, height: 32)
            
            // Title
            Text(intention.title)
                .font(.s16Medium)
                .foregroundStyle(Color("brand-color"))
            
            Spacer()
            
            // Delete button
            Button {
                deleteIntention(intention)
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("base-shade-01"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func deleteIntention(_ intention: Intention) {
        // Only allow deletion if there are more than 3 intentions
        guard intentions.count > 3 else {
            return
        }
        modelContext.delete(intention)
        try? modelContext.save()
    }
}

#Preview {
    ManageIntentionsView()
}
