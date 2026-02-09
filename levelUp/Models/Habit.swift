//
//  Habit.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import Foundation
import SwiftData

@Model
class Habit: Identifiable {
    var id = UUID().uuidString
    var title: String
    var isEnabled: Bool = true
    @Transient
    var type: HabitType = .water
    
    @Transient
    var displayType: HabitDisplayType = .square

    @Transient
    var stepsCount: Int = 0
    @Transient
    var waterIntake: Int = 0
    @Transient
    var lastWaterDate: Date? = nil

    init(id: String, title: String, type: HabitType, isEnabled: Bool)  {
        self.id = id
        self.title = title
        self.type = type
        self.isEnabled = isEnabled
    }
}

enum HabitType {
    case water
    case steps
    case wakeUp
}

enum HabitDisplayType {
    case square
    case rectangle
    case fullWidth
}

// General Structure for Habit Managements
protocol HabitManager  {
    var id: String { get set }
    var name: String { get set }
    func calculateHabitProgress()
}

struct StepsManager: HabitManager {
    var id: String
    var name: String
    func calculateHabitProgress() {
        //Custom for each habit
    }
    var stepCount: Int
    var isCompleted: Bool
}
