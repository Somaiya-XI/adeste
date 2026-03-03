//
//  SymbolView.swift
//  levelUp
//
//  Created by yumii on 11/02/2026.
//

import SwiftUI

struct SymbolView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedSymbol: String
    @State private var searchText: String = ""
    
    // Filter symbols based on search text
    private var filteredSymbols: [String] {
        if searchText.isEmpty {
            return SymbolLoader.symbols
        }
        return SymbolLoader.symbols.filter { symbolName in
            symbolName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.s16Medium)
                    .foregroundStyle(Color("brand-color"))
                
                TextField("Search...", text: $searchText)
                    .font(.s16Medium)
                    .foregroundStyle(Color("brand-color"))
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.s18Medium)
                            .foregroundStyle(Color("brand-color"))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color("base-shade-01"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)
            
            // Symbol Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredSymbols, id: \.self) { symbolName in
                        Button {
                            selectedSymbol = symbolName
                            dismiss()
                        } label: {
                            Image(systemName: symbolName)
                                .font(.s20Medium)
                                .foregroundStyle(Color("brand-color"))
                                .frame(width: 50, height: 50)
                                .background(symbolName == selectedSymbol ? Color("base-shade-03") : Color.clear)
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
        .background(Color.white)
    }
}

#Preview {
    SymbolView(selectedSymbol: .constant("heart.fill"))
}
