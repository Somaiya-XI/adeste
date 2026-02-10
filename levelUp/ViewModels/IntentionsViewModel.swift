//
//  IntentionsViewModel.swift
//  Adeste
//
//  Created by Somaiya on 21/08/1447 AH.
//

import SwiftData

@Observable
class IntentionsViewModel {
    private var manager: IntentionManager?
    
    var currentIntention: Intention?
    
    func configure(with modelContext: ModelContext) {
        self.manager = IntentionManager(modelContext: modelContext)
    }
    
    func getIntentions() -> [Intention] {
        manager?.fetchAllIntentions() ?? []
    }
    
    func getIntentionsSummary() -> IntentionSummary {
        manager?.calculateWeeklySummary() ?? IntentionSummary()
    }
    
    func addIntention(title: String, icon: String = "plus") {
        let intention = Intention(title: title, icon: icon)
        manager?.addIntention(intention)
    }
    
    func recordFocus(for intention: Intention) {
        manager?.registerFocus(for: intention)
    }
    
    func recordDistraction(for intention: Intention) {
        manager?.registerDistraction(for: intention)
    }
    
    func deleteIntention(_ intention: Intention) {
        manager?.deleteIntention(intention)
    }
    
    func triggerNotification(for intention: Intention){
        manager?.triggerNotification(for: intention)
    }
}
