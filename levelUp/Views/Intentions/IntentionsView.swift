//
//  IntentionsView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI
import SwiftData
import Combine
import FamilyControls

struct IntentionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Intention.title) private var intentions: [Intention]
    
    @State private var selectedIntentionIcon: String? = nil
    @State private var stopwatchTime: TimeInterval = 0
    @State private var isEditing = false
    @State private var tempIntention: Intention? = nil
    @State private var isAddingNew = false
    @State var focusRatio: Double = 0.5
    
    // Computed property for current intentions count
    private var currentIntentionsCount: Int {
        intentions.count
    }  

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
            
                    HStack {
                        // Centered title
                        Text(consts.intentionpageStr)
                            .font(.s32Medium)
                            .foregroundStyle(Color("brand-color"))
                        Spacer(minLength: 0)
                        Button {
                            withAnimation {
                                isEditing.toggle()
                            }
                        } label: {
                            Image(systemName: isEditing ? consts.checkmarkIcon : consts.editIcon)
                                .font(.s24Medium)
                                .foregroundStyle(Color("brand-color"))
                                .frame(width: 40, height: 40)
                                .background(Color("base-shade-02"))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                     .padding(.top, 10)
                    .padding(.bottom, 20)
     
                    
            Spacer().frame(height: 16)

            // Card: Intention / Stopwatch
            VStack(alignment: .leading, spacing: 16) {
                if let icon = selectedIntentionIcon {
                    // Stopwatch Mode: User picked an intention, so we show the running timer
                    Text(consts.currentIntentionStr)
                        .font(.s24Medium)
                        .foregroundStyle(Color("brand-color"))

                    Spacer().frame(height: 12)

                    VStack(spacing: 16) {
                        Image(systemName: icon)
                            .font(.s24Medium)
                            .foregroundStyle(Color("brand-color"))
                            .frame(width: 48, height: 48)
                            .background(Color("base-shade-03"))
                            .clipShape(Circle())

                        Text(formattedStopwatchTime)
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                            .monospacedDigit()
                            .foregroundStyle(Color("brand-color"))

                        Button(consts.stopStr) {
                            selectedIntentionIcon = nil
                            stopwatchTime = 0
                        }
                        .font(.s12Medium)
                        .foregroundStyle(Color("brand-color"))
                    }
                    .frame(maxWidth: .infinity)
                    .onAppear {
                        stopwatchTime = 0 
                    }
                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                        stopwatchTime += 1
                    }
                } else {
                    // Selection Mode: User has not picked yet, so we show the grid of intentions
                    Text(consts.startIntentionStr)
                        .font(.s24Medium)
                        .foregroundStyle(Color("brand-color"))

                    // Max 6 intentions
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(intentions) { intention in
                            intentionButton(intention: intention, isEditing: isEditing && tempIntention == nil, onLongPress: { isEditing = true })
                        }
                        
                        if currentIntentionsCount < 6 {
                            addMoreButton
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 227)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color("base-shade-01"))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer().frame(height: 36)

            // Weekly Summary
            HStack {
                Text(consts.weeklySummaryStr)
                    .font(.s28Medium)
                    .foregroundStyle(Color("brand-color"))
                Spacer(minLength: 0)
            }

            Spacer().frame(height: 16)

            // Donut Chart
            ZStack {
                 Circle()
                    .trim(from: 0.0, to: focusRatio)
                    .stroke(Color("sec-color-berry"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
 
                 Circle()
                    .trim(from: focusRatio, to: 0.99)
                    .stroke(Color("sec-color-mustard"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 0) {
                    Text("\(Int(focusRatio * 100))%")
                        .font(.s48Heavy)
                        .foregroundStyle(Color("brand-color"))
                    Text(consts.focusedStr)
                        .font(.s12Light)
                        .foregroundStyle(Color("brand-color"))
                }
            }
            .frame(width: 200, height: 200)

            Spacer().frame(height: 36)

            Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                
                // Edit Intention Popup
                if let intention = tempIntention {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            tempIntention = nil
                        }
                    
                    EditIntentionPopup(
                        intention: intention,
                        isAddingNew: isAddingNew,
                        existingIntentions: intentions,
                        canDelete: currentIntentionsCount > 3 && !isAddingNew,
                        onCancel: {
                            tempIntention = nil
                        },
                        onSave: { updatedIntention in
                            if isAddingNew {
                                modelContext.insert(updatedIntention)
                            }
                            // For updates, the EditIntentionPopup modifies the existing object directly
                            try? modelContext.save()
                            tempIntention = nil
                        },
                        onDelete: {
                            if currentIntentionsCount > 3, let intentionToDelete = tempIntention {
                                modelContext.delete(intentionToDelete)
                                try? modelContext.save()
                                tempIntention = nil
                            }
                        }
                    )
                }
            }
             
        }
    }

   
    private var formattedStopwatchTime: String {
        let total = Int(stopwatchTime)
        
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    // Add more
    private var addMoreButton: some View {
        Button {
            let newIntention = Intention(title: "", icon: consts.plusIcon)
            tempIntention = newIntention
            isAddingNew = true
        } label: {
            actionButtonContent(icon: consts.plusIcon, label: consts.addMoreStr, isEditing: false)
        }
        .buttonStyle(.plain)
    }

    
    private func intentionButton(intention: Intention, isEditing: Bool, onLongPress: @escaping () -> Void) -> some View {
        Button {
             if isEditing {
                 tempIntention = intention // Use the actual SwiftData object
                isAddingNew = false
            } else {
                // Start Timer
                selectedIntentionIcon = intention.icon
            }
        } label: {
            actionButtonContent(icon: intention.icon, label: intention.title, isEditing: isEditing)
        }
        .buttonStyle(.plain)
        .onLongPressGesture {
            withAnimation {
                onLongPress()
            }
        }
    }

    private func actionButtonContent(icon: String, label: String, isEditing: Bool) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.s24Medium)
                .foregroundStyle(Color("brand-color"))
                .frame(width: 48, height: 48)
                .background(Color("base-shade-03"))
                .clipShape(Circle())

            Text(label)
                .font(.s16Medium)
                .foregroundStyle(Color("brand-color"))
        }
        .rotationEffect(.degrees(isEditing ? 2 : -2))
        .offset(x: isEditing ? 1 : -1)
        .animation(
            isEditing
            ? .linear(duration: 0.12).repeatForever(autoreverses: true)
            : .default,
            value: isEditing
        )
    }
}

struct EditIntentionPopup: View {
    let intention: Intention
    let isAddingNew: Bool
    let existingIntentions: [Intention]
    let canDelete: Bool
    let onCancel: () -> Void
    let onSave: (Intention) -> Void
    let onDelete: () -> Void
    
    @State private var editedTitle: String
    @State private var editedIcon: String
    @State private var showFamilyActivityPicker = false
    @State private var familyActivitySelection = FamilyActivitySelection()
    @State private var showIconPicker = false
    
    init(intention: Intention, isAddingNew: Bool, existingIntentions: [Intention], canDelete: Bool, onCancel: @escaping () -> Void, onSave: @escaping (Intention) -> Void, onDelete: @escaping () -> Void) {
        self.intention = intention
        self.isAddingNew = isAddingNew
        self.existingIntentions = existingIntentions
        self.canDelete = canDelete
        self.onCancel = onCancel
        self.onSave = onSave
        self.onDelete = onDelete
        _editedTitle = State(initialValue: intention.title)
        _editedIcon = State(initialValue: intention.icon)
        // Initialize familyActivitySelection - note: FamilyActivitySelection doesn't have a direct init from [String]
        // So we start with empty selection and user can pick apps
        _familyActivitySelection = State(initialValue: FamilyActivitySelection())
    }
    
    // Check if title is not empty and not duplicate
    private var isValid: Bool {
        let trimmedTitle = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            return false
        }
        
        let titleExists = existingIntentions.contains { existingIntention in
            // When editing, ignore the current intention's own title
            if !isAddingNew && existingIntention.id == intention.id {
                return false
            }
            return existingIntention.title.lowercased() == trimmedTitle.lowercased()
        }
        
        return !titleExists
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text(isAddingNew ? consts.newIntentionStr : consts.editIntentionStr)
                .font(.s24Medium)
                .foregroundStyle(Color("brand-color"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
             HStack(spacing: 16) {
                 Button {
                    showIconPicker = true
                } label: {
                    ZStack {
                        Image(systemName: editedIcon)
                            .font(.s24Medium)
                            .foregroundStyle(Color("brand-color"))
                            .frame(width: 48, height: 48)
                            .background(Color("base-shade-03"))
                            .clipShape(Circle())
                        
                        // Visual hint: Small pencil badge overlay
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color("brand-color"))
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: 16, y: 16)
                    }
                }
                .buttonStyle(.plain)
                
                 VStack(alignment: .leading, spacing: 4) {
                    TextField("Intention Name", text: $editedTitle)
                        .font(.s20Medium)
                        .foregroundStyle(Color("brand-color"))
                        .textFieldStyle(.plain)
                    Rectangle()
                        .fill(Color("brand-color"))
                        .frame(height: 1)
                }
            }
            
            // Apps Section: Managed Apps Link
            Button {
                showFamilyActivityPicker = true
            } label: {
                VStack(alignment: .leading, spacing: 8) {
                    Text(consts.managedAppsStr)
                        .font(.s16Medium)
                        .foregroundStyle(Color("brand-color"))
                    Text(familyActivitySelection.applicationTokens.isEmpty ? "No apps selected" : "\(familyActivitySelection.applicationTokens.count) apps selected")
                        .font(.s12Medium)
                        .foregroundStyle(Color("brand-color").opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(Color("base-shade-02"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showFamilyActivityPicker) {
                FamilyActivityPicker(selection: $familyActivitySelection)
            }
            
             HStack(spacing: 16) {
                Button(consts.cancelStr) {
                    onCancel()
                }
                .font(.s16Medium)
                .foregroundStyle(Color("brand-color"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("brand-color"), lineWidth: 1)
                )
                
                Button(consts.saveStr) {
                    if isAddingNew {
                        // Create new intention
                        let newIntention = Intention(title: editedTitle.trimmingCharacters(in: .whitespacesAndNewlines), icon: editedIcon)
                        // Save the selected apps from FamilyActivityPicker
                        if !familyActivitySelection.applicationTokens.isEmpty {
                            newIntention.apps = familyActivitySelection.applicationTokens.compactMap { token in
                                if let encoded = try? JSONEncoder().encode(token),
                                   let encodedString = String(data: encoded, encoding: .utf8) {
                                    return encodedString
                                }
                                return nil
                            }
                        }
                        onSave(newIntention)
                    } else {
                        // Update existing intention directly (SwiftData will track changes)
                        intention.title = editedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                        intention.icon = editedIcon
                        // Save the selected apps from FamilyActivityPicker
                        if !familyActivitySelection.applicationTokens.isEmpty {
                            intention.apps = familyActivitySelection.applicationTokens.compactMap { token in
                                if let encoded = try? JSONEncoder().encode(token),
                                   let encodedString = String(data: encoded, encoding: .utf8) {
                                    return encodedString
                                }
                                return nil
                            }
                        } else {
                            intention.apps = nil
                        }
                        onSave(intention)
                    }
                }
                .font(.s16Medium)
                .foregroundStyle(isValid ? Color.white : Color.gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isValid ? Color("brand-color") : Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(!isValid)
            }
            
            if !isAddingNew && existingIntentions.count > 3 {
                Button {
                    onDelete()
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
        // Icon Picker Sheet (Notion-style)
        .sheet(isPresented: $showIconPicker) {
            SymbolView(selectedSymbol: $editedIcon)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    IntentionsView()
}

 
