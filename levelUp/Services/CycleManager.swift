//
//  CycleManager.swift
//  adeste
//
//  Created by Somaiya on 27/08/1447 AH.
//

import Foundation
import SwiftData

class CycleManager {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        populateDefaultCycles()

    }
    
    private func populateDefaultCycles() {
        let cycles = fetchAllCycles()
        
        if cycles.isEmpty {
            let starterCycles = [
                Cycle(cycleType: .starter, cycleDuration: .starter, desc:
                      "Seven days to interrupt autopilot. \nNotice your habits, reduce distractions, and regain control."),
                Cycle(cycleType: .basic, cycleDuration: .basic, desc: "Fourteen days to strengthen new patter. \nRepetition builds clarity, control, and focus. Stay consistent and feel the shift"),
                Cycle(cycleType: .advanced, cycleDuration: .advanced, desc:
                        "Twenty-one days to rewire your routine. \nWith steady practice, focus starts to feel natural. Build habits that last beyond the cycle.")
            ]
            
            for cycle in starterCycles {
                addCycle(cycle)
            }
        }
    }
    
    // CRUD Operations
    func fetchAllCycles() -> [Cycle] {
        let descriptor = FetchDescriptor<Cycle>(sortBy: [SortDescriptor(\.title)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func addCycle(_ cycle: Cycle) {
        modelContext.insert(cycle)
        saveContext()
    }
    
    private func deleteCycle(_ cycle: Cycle) {
        modelContext.delete(cycle)
        saveContext()
    }
    
    private func updateCycle(_ cycle: Cycle) {
        saveContext()
    }
    
    private func saveContext() {
        try? modelContext.save()
    }
}
