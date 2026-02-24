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
        Intention(title: "Studying", icon: "book.pages.fill"),
        Intention(title: "Playing", icon: "gamecontroller.fill"),
        Intention(title: "Playing", icon: "gamecontroller"),
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


@MainActor
let previewContainer2: ModelContainer = {
     var cycles: [Cycle] = [
        Cycle(cycleType: .starter, cycleDuration: .starter, desc:
              "Seven days to interrupt autopilot. \nNotice your habits, reduce distractions, and regain control."),
        Cycle(cycleType: .basic, cycleDuration: .basic, desc: "Fourteen days to strengthen new patter. \nRepetition builds clarity, control, and focus. Stay consistent and feel the shift"),
        Cycle(cycleType: .advanced, cycleDuration: .advanced, desc:
                "Twenty-one days to rewire your routine. \nWith steady practice, focus starts to feel natural. Build habits that last beyond the cycle.")
    ]
    do {
        let container = try ModelContainer(for: Cycle.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        for cycle in cycles {
            container.mainContext.insert(cycle)
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()


