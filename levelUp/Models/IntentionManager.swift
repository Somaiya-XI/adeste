//
//  IntentionManager.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData

@Model
class IntentionManager: Identifiable {
    var id: UUID
    var intentions: [Intention]?
    var weeklySummary: Double?
    
    public init(id: UUID = UUID(), intentions: [Intention]) {
        self.id = id
        self.intentions = []
    }
}

