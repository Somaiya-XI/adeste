//
//  Habit.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData
import Adhan


@Model
class Habit: Identifiable {
    var id = UUID().uuidString
    var title: String
    var isEnabled: Bool = true
    var typeRawValue: String
    
    // Habit-specific data
    var waterIntake: Int = 0
    var stepsCount: Int = 0
    var wakeUpTime: Date?

    
    init(id: String, title: String, type: HabitType, isEnabled: Bool)  {
        self.id = id
        self.title = title
        self.typeRawValue = type.rawValue
        self.isEnabled = isEnabled
    }
}



enum HabitType: String, Codable {
    case water
    case steps
    case wakeUp
    case prayer
    case athkar

    
}



// General Structure for Habit Managements
protocol HabitManager  {
    var id: String { get set }
    var name: String { get set }
    func calculateHabitProgress()
}


extension Habit {
    convenience init(title: String, type: HabitType) {
        self.init(
            id: UUID().uuidString,
            title: title,
            type: type,
            isEnabled: true
        )
    }
}
extension Habit {
    var type: HabitType {
        HabitType(rawValue: typeRawValue) ?? .water
    }
}


