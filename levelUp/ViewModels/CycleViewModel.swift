//
//  IntentionsViewModel.swift
//  Adeste
//
//  Created by Somaiya on 21/08/1447 AH.
//

import SwiftData


@Observable
class CycleViewModel {
    
    var currentCycle: Cycle?
    var isCompleted: Bool = false
    
    var showStopwatchAlert: Bool = false
    
    private var manager: CycleManager?
    
    func configure(with modelContext: ModelContext) {
        self.manager = CycleManager(modelContext: modelContext)
    }

}
