//
//  IntentionManager.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData


struct IntentionSummary: Codable {
    var totalFocus: Double = 0.0
    var totalDistraction: Double = 0.0
    var totalTriggeredIntentions: Double = 0.0
    var focusPercentage: Double = 0.0
    var distractionPercentage: Double = 0.0
}

import SwiftData

class IntentionManager {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // CRUD Operations
    func fetchAllIntentions() -> [Intention] {
        let descriptor = FetchDescriptor<Intention>(sortBy: [SortDescriptor(\.title)])
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addIntention(_ intention: Intention) {
        modelContext.insert(intention)
        saveContext()
    }
    
    func deleteIntention(_ intention: Intention) {
        modelContext.delete(intention)
        saveContext()
    }
    
    func updateIntention(_ intention: Intention) {
        saveContext()
    }
    
    // Business Logic
    func calculateWeeklySummary() -> IntentionSummary {
        let intentions = fetchAllIntentions()
        var summary = IntentionSummary()
        
        for intention in intentions {
            summary.totalFocus += intention.focus
            summary.totalDistraction += intention.distraction
        }
        
        summary.totalTriggeredIntentions = summary.totalFocus + summary.totalDistraction
        
        if summary.totalTriggeredIntentions > 0 {
            summary.focusPercentage = (summary.totalFocus / summary.totalTriggeredIntentions) * 100
            summary.distractionPercentage = (summary.totalDistraction / summary.totalTriggeredIntentions) * 100
        }
        
        return summary
    }
    
    func registerFocus(for intention: Intention) {
        intention.registerFocus()
        saveContext()
    }
    
    func registerDistraction(for intention: Intention) {
        intention.registerDistraction()
        saveContext()
    }
    
    private func saveContext() {
        try? modelContext.save()
    }
}
