//
//  User.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation

// it can be a swiftData OR AppStorage
struct User: Codable {
    var id: String
    var name: String
    var currentCycleId: String
    var currentCycleType: CycleType
//    var cycleHistory: [Cycle]?
    var streak: Int
    var habits: [Habit]?
    
    init(name: String, currentCycleId: String, currentCycleType: CycleType = .starter,streak: Int, habits: [Habit]? = nil) {
        self.id = UUID().uuidString
        self.name = name
        self.currentCycleId = currentCycleId
        self.currentCycleType = currentCycleType
        self.streak = streak
        self.habits = habits
    }
}

