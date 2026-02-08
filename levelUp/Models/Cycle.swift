//
//  Cycle.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData

enum CycleType: String, Codable, CaseIterable {
    case Basic
    case Medium
    case Advanced
}

enum CycleDuration: Int, Codable, CaseIterable {
    case basic = 1
    case medium = 2
    case advanced = 3
}

@Model
class Cycle: Identifiable {
    var id: String
    var cycleType: CycleType
    var cycleDuration: CycleDuration
    
    init(id: String, cycleType: CycleType, cycleDuration: CycleDuration)  {
        self.id = id
        self.cycleType = cycleType
        self.cycleDuration = cycleDuration
    }
}
