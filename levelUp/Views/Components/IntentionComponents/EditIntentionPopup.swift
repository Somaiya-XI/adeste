//
//  EditIntentionPopup.swift
//  adeste
//
//  Created by Somaiya on 23/08/1447 AH.
//

import SwiftUI
import SwiftData
import FamilyControls

struct EditIntentionPopup: View {
    var viewModel: IntentionsViewModel
    @Query var intentions: [Intention]
//    let onCancel: () -> Void
//    let onSave: (Intention) -> Void
//    let onDelete: () -> Void
//
    
    @State var editedTitle: String = ""
    @State var editedIcon: String = "target"
//    @State private var showFamilyActivityPicker = false
//    @State private var familyActivitySelection = FamilyActivitySelection()

    
    private func syncFromIntention() {
        guard let intention = viewModel.currentlyEditing else { return }
        if editedTitle != intention.title { editedTitle = intention.title }
        if editedIcon != intention.icon { editedIcon = intention.icon }
    }
    
    /// Check if title is not empty and not duplicate
    private var isValid: Bool {
        let trimmedTitle = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            return false
        }
        
        guard let intention = viewModel.currentlyEditing else { return false}
        
        let titleExists = intentions.contains { existingIntention in
            /// When editing, ignore the current intention's own title
            if !viewModel.isCreating && existingIntention.id == intention.id {
                return false
            }
            return existingIntention.title.lowercased() == trimmedTitle.lowercased()
        }
        
        return !titleExists
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.isCreating ? consts.newIntentionStr : consts.editIntentionStr)
                .font(.s24Medium)
                .foregroundStyle(.brand)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            IntentionsSymbolPicker(icon: $editedIcon, title: $editedTitle)
            
             HStack(spacing: 16) {
                Button(consts.cancelStr) {
                    viewModel.currentlyEditing = nil
                }
                .font(.s16Medium)
                .foregroundStyle(.brand)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.brand, lineWidth: 1)
                )
                
                Button(consts.saveStr) {
                    // Create updated intention
                    
                    guard let intention = viewModel.currentlyEditing else { return }

                    intention.title = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                        intention.icon = editedIcon
                        
                        if viewModel.isCreating {
                            viewModel.addIntention(intention)
                        } else {
                            viewModel.updateIntention(intention)
                        }
                        viewModel.currentlyEditing = nil
                    viewModel.isCreating = false

                    
                }
                .font(.s16Medium)
                .foregroundStyle(isValid ? Color.white : Color.gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isValid ? .brand : Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(!isValid)
            }
            
            if !viewModel.isCreating && intentions.count > viewModel.minimumIntentions {
                Button {
                    guard let intention = viewModel.currentlyEditing else { return }
                    viewModel.deleteIntention(intention)
                    viewModel.currentlyEditing = nil

                } label: {
                    Text(consts.deleteIntentionStr)
                        .font(.s16Medium)
                        .foregroundStyle(Color.red)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .onAppear {
            syncFromIntention()
            viewModel.isEditing = false
        }
        .onChange(of: viewModel.currentlyEditing?.id) { _, _ in
            syncFromIntention()
        }
        .onChange(of: viewModel.currentlyEditing) { oldValue, newValue in
            if newValue != nil {
                syncFromIntention()
            }
        }
    }
}

#Preview {
    EditIntentionPopup(viewModel: IntentionsViewModel())
}
