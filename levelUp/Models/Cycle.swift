//
//  Cycle.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData

enum CycleType: String, Codable, CaseIterable {
    case starter = "Awareness"
    case basic = "Consistency"
    case advanced = "Foundation"
    case premium = "Growth"
}

enum CycleDuration: Int, Codable, CaseIterable {
    case starter = 7
    case basic = 14
    case advanced = 21
    case premium = 30
}

@Model
class Cycle: Identifiable, Hashable {
    var id: String
    var title: String
    var cycleType: CycleType
    var cycleDuration: CycleDuration
    var desc: String
    
    var maxHabits: Int {
        switch self.cycleType {
            case .starter: return 2
            case .basic: return 3
            case .advanced: return 5
            case .premium: return 7
        }
    }
    
    var image: String {
        switch self.cycleType {
            case .starter: return "Sleepy-expression"
            case .basic: return "Serious-expression"
            case .advanced: return "Fire-expression"
            case .premium: return "Fire-expression"
        }
    }
    
    init(title: String = "", cycleType: CycleType, cycleDuration: CycleDuration, desc: String = "")  {
        self.id = UUID().uuidString
        self.title = title.isEmpty ? cycleType.rawValue : title
        self.cycleType = cycleType
        self.cycleDuration = cycleDuration
        self.desc = desc
    }
}
