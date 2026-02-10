//
//  MockData.swift
//  adeste
//
//  Created by Somaiya on 22/08/1447 AH.
//

import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
     var intentions: [Intention] = [
        Intention(title: "Texting", icon: "message.badge.filled.fill"),
        Intention(title: "Studying", icon: "book.pages.fill"),
        Intention(title: "Playing", icon: "gamecontroller.fill")
    ]
    do {
        let container = try ModelContainer(for: Intention.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        for intention in intentions {
            container.mainContext.insert(intention)
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
