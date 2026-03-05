//
//  Cycle.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData

enum CycleType: String, Codable, CaseIterable {
    case starter = "Light"
    case basic = "Balanced"
    case advanced = "Deep"
    case premium = "Growth"
    // Legacy raw values (persisted data may contain these); map to current behavior
    case awareness = "Awareness"      // → same as starter (Light)
    case consistency = "Consistency"  // → same as basic (Balanced)
    case foundation = "Foundation"    // → same as advanced (Deep)

    var displayName: String {
        switch self {
        case .starter, .awareness: return "Light"
        case .basic, .consistency: return "Balanced"
        case .advanced, .foundation: return "Deep"
        case .premium: return "Growth"
        }
    }

    var screenTimeChangeLimit: Int {
        switch self {
        case .starter, .awareness: return 1
        case .basic, .consistency: return 2
        case .advanced, .foundation, .premium: return 3
        }
    }
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
        case .starter, .awareness: return 2
        case .basic, .consistency: return 3
        case .advanced, .foundation: return 5
        case .premium: return 7
        }
    }

    var image: String {
        switch self.cycleType {
        case .starter, .awareness: return "Sleepy-expression"
        case .basic, .consistency: return "Serious-expression"
        case .advanced, .foundation, .premium: return "Fire-expression"
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
