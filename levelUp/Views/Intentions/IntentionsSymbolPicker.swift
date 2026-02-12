//
//  IntentionsSymbolPicker.swift
//  adeste
//
//  Created by yumii on 11/02/2026.
//

import SwiftUI

struct IntentionsSymbolPicker: View {
    @Binding var icon: String
    @Binding var title: String
    @State private var showIconPicker = false

    var body: some View {
        HStack(spacing: 16) {
            Button {
               showIconPicker = true
           } label: {
               ZStack {
                   Image(systemName: icon)
                       .font(.s24Medium)
                       .foregroundStyle(Color("brand-color"))
                       .frame(width: 48, height: 48)
                       .background(Color("base-shade-03"))
                       .clipShape(Circle())
                   
                    Image(systemName: "pencil.circle.fill")
                       .font(.s16Medium)
                       .foregroundStyle(Color("brand-color"))
                       .background(Color.white)
                       .clipShape(Circle())
                       .offset(x: 16, y: 16)
               }
           }
           .buttonStyle(.plain)
           
            VStack(alignment: .leading, spacing: 4) {
                TextField("Intention Name", text: $title)
                   .font(.s20Medium)
                   .foregroundStyle(Color("brand-color"))
                   .textFieldStyle(.plain)
               Rectangle()
                   .fill(Color("brand-color"))
                   .frame(height: 1)
           }
       }
        .sheet(isPresented: $showIconPicker) {
            SymbolView(selectedSymbol: $icon)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    IntentionsSymbolPicker(icon: .constant("heart.fill"), title: .constant("Sample Intention"))
}
