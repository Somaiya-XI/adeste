//
//  EditNamePopup.swift
//  levelUp
//
//  Created by yumii on 11/02/2026.
//

import SwiftUI

struct EditNamePopup: View {
    @Binding var userName: String
    @Binding var isPresented: Bool
    
    @State private var editedName: String
    
    init(userName: Binding<String>, isPresented: Binding<Bool>) {
        self._userName = userName
        self._isPresented = isPresented
        _editedName = State(initialValue: userName.wrappedValue)
    }
    
    private var isValid: Bool {
        !editedName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Change Name")
                .font(.s24Medium)
                .foregroundStyle(Color("brand-color"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
             VStack(alignment: .leading, spacing: 4) {
                TextField("Name", text: $editedName)
                    .font(.s20Medium)
                    .foregroundStyle(Color("brand-color"))
                    .textFieldStyle(.plain)
                    .textInputAutocapitalization(.words)
                Rectangle()
                    .fill(Color("brand-color"))
                    .frame(height: 1)
            }
            
             HStack(spacing: 16) {
                Button(consts.cancelStr) {
                    isPresented = false
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
                    let trimmedName = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmedName.isEmpty {
                        userName = trimmedName
                    }
                    isPresented = false
                }
                .font(.s16Medium)
                .foregroundStyle(isValid ? Color.white : Color.gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isValid ? Color("brand-color") : Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .disabled(!isValid)
            }
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.45)
            .ignoresSafeArea()
        
        EditNamePopup(
            userName: .constant("My Name"),
            isPresented: .constant(true)
        )
    }
}
