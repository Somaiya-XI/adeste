//
//  IntentionsViewModel.swift
//  Adeste
//
//  Created by Somaiya on 21/08/1447 AH.
//

import SwiftData
enum IntentionsViewMode{
    case timer
    case main
}

@Observable
class IntentionsViewModel {
    
    var allowedIntentions: Int = 6
    var minimumIntentions: Int = 3
    
    var isEditing: Bool = false
    var isCreating: Bool = false
    
    var viewMode: IntentionsViewMode = .main
    var currentIntention: Intention?
    var currentlyEditing: Intention?
    
    var showStopwatchAlert: Bool = false
    
    private var manager: IntentionManager?
    
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
    
    func addIntention(_ intention: Intention) {
        manager?.addIntention(intention)
    }
    
    func updateIntention(_ intention: Intention) {
        manager?.updateIntention(intention)
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
