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
    
    @State private var viewModel = IntentionsViewModel()
    @State private var selectedIntention: Intention? = nil
    
    private var canDelete: Bool {
        intentions.count > 3
    }
    
    private var canAdd: Bool {
        intentions.count < 6
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                     ZStack {
                        Text(consts.manageIntentionsStr)
                            .font(.s24Semibold)
                            .foregroundStyle(Color("brand-color"))
                        
                        HStack {
                            BackButton(action: { dismiss() })
                            Spacer()
                            if canAdd {
                                Button {
                                    let newIntention = Intention()
                                    viewModel.currentlyEditing = newIntention
                                    viewModel.isCreating = true
                                    selectedIntention = newIntention
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.s16Semibold)
                                        .foregroundStyle(Color("brand-color"))
                                        .frame(width: 40, height: 40)
                                        .background(Color("base-shade-02").opacity(0.5))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 24)
                    
                    // Card-based list
                    if intentions.isEmpty {
                        VStack(spacing: 16) {
                            Text("No intentions yet")
                                .font(.s16Medium)
                                .foregroundStyle(Color("base-shade-02"))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.vertical, 40)
                    } else {
                        List {
                            ForEach(intentions) { intention in
                                IntentionCardRow(
                                    intention: intention,
                                    onTap: {
                                        viewModel.currentlyEditing = intention
                                        viewModel.isCreating = false
                                        selectedIntention = intention
                                    }
                                )
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    if canDelete {
                                        Button(role: .destructive) {
                                            deleteIntention(intention)
                                        } label: {
                                            Image(systemName: "trash.fill")
                                        }
                                        .buttonStyle(.automatic)
                                        .tint(Color("brand-color"))
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                viewModel.configure(with: modelContext)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .overlay {
                // Edit Intention Popup
                if let intention = selectedIntention {
                    ZStack {
                        Color.black.opacity(0.45)
                            .ignoresSafeArea()
                            .onTapGesture {
                                viewModel.currentlyEditing = nil
                                selectedIntention = nil
                            }
                        EditIntentionPopupWrapper(
                            intention: intention,
                            viewModel: viewModel,
                            onDismiss: {
                                selectedIntention = nil
                            }
                        )
                    }
                }
            }
        }
    }
    
    private func deleteIntention(_ intention: Intention) {
        guard intentions.count > 3 else { return }
        withAnimation(.easeOut(duration: 0.25)) {
            modelContext.delete(intention)
            try? modelContext.save()
        }
    }
}

// IntentionCardRow
private struct IntentionCardRow: View {
    let intention: Intention
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon (leading)
                Image(systemName: intention.icon)
                    .font(.s20Semibold)
                    .foregroundStyle(Color("brand-color"))
                    .frame(width: 44, height: 44)
                    .background(Color("base-shade-03"))
                    .clipShape(Circle())
                
                // Name
                Text(intention.title)
                    .font(.s18Medium)
                    .foregroundStyle(Color("brand-color"))
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("base-shade-01"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("brand-color").opacity(0.12), lineWidth: 1)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// EditIntentionPopupWrapper
struct EditIntentionPopupWrapper: View {
    let intention: Intention
    @Bindable var viewModel: IntentionsViewModel
    let onDismiss: () -> Void
    
    var body: some View {
        EditIntentionPopup(viewModel: viewModel)
            .onAppear {
                viewModel.currentlyEditing = intention
                // isCreating is set by caller (Add sets true, card tap sets false)
            }
            .onChange(of: viewModel.currentlyEditing) { oldValue, newValue in
                if newValue == nil {
                    onDismiss()
                }
            }
    }
}

#Preview {
    ManageIntentionsView()
}
