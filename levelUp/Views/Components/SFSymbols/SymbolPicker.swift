//
//  SymbolPicker.swift
//  levelUp
//
//  Created by yumii on 11/02/2026.
//

import SwiftUI

/// A convenient wrapper around SymbolView for selecting SF Symbols
struct SymbolPicker: View {
    @Binding var selection: String
    
    var body: some View {
        SymbolView(selectedSymbol: $selection)
    }
}

#Preview {
    SymbolPicker(selection: .constant("plus.circle.fill"))
}
