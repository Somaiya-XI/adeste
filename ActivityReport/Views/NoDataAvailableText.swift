//
//  NoDataAvailableText.swift
//  DeviceActivityReport
//
//  Created by Itsuki on 2025/12/08.
//

import SwiftUI

struct NoDataAvailableText: View {
    init(_ text: String) {
        self.text = text
    }
    var text: String
    var body: some View {
        Text(text)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.leading)
    }
}
