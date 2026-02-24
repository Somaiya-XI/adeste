//
//  TwoColumnText.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

import SwiftUI

struct TwoColumnText: View {
    init(_ left: String, _ right: String) {
        self.left = left
        self.right = right
    }
    
    var left: String
    var right: String
    var body: some View {
        HStack {
            Text(left)
                .lineLimit(1)
                .fontWeight(.medium)
            Spacer()
            Text(right)
                .lineLimit(1)
                .foregroundStyle(.secondary)
        }
    }
}
