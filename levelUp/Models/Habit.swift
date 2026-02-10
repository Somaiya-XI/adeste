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
    var stepsCount: Int = 0
    
    @Transient
    var waterIntake: Int = 0
    @Transient
    var lastWaterDate: Date? = nil
    @Transient
    var waterIncreaseCount: Int = 0
    
    @Transient
    var wakeUpTime: Date?          // 07:00
    @Transient
    var wakeUpWindow: TimeInterval = 1800 // 30 دقيقة
    @Transient
    var didCheckIn: Bool = false
    @Transient
    var checkInDate: Date? = nil

    
    init(id: String, title: String, type: HabitType, isEnabled: Bool)  {
        self.id = id
        self.title = title
        self.type = type
        self.isEnabled = isEnabled
    }
}

import SwiftUI

enum HabitType: String, Codable {
    case water
    case steps
    case wakeUp

    var color: Color {
        switch self {
        case .water:
            return .secColorBlue
        case .steps:
            return .secColorBerry
        case .wakeUp:
            return .secColorMustard
        }
    }
}
enum WakeUpStatus {
    case notSet
    case upcoming
    case active
    case completed
    case missed
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
    func canIncreaseWater() -> Bool {
        let now = Date()
        let limit: TimeInterval = 5400 // 1.5 ساعة

        guard let lastDate = lastWaterDate else {
            lastWaterDate = now
            waterIncreaseCount = 1
            return true
        }

        if now.timeIntervalSince(lastDate) > limit {
            lastWaterDate = now
            waterIncreaseCount = 1
            return true
        }

        if waterIncreaseCount < 2 {
            waterIncreaseCount += 1
            return true
        }

        return false
    }
}
extension Habit {

    func canCheckInWakeUp() -> Bool {
        guard let wakeUpTime else { return false }

        let now = Date()
        let endWindow = wakeUpTime.addingTimeInterval(wakeUpWindow)

        return now >= wakeUpTime && now <= endWindow && !didCheckIn
    }

    func checkInWakeUp() -> Bool {
        guard canCheckInWakeUp() else { return false }

        didCheckIn = true
        checkInDate = Date()
        return true
    }

    var wakeUpStatus: WakeUpStatus {
        guard let wakeUpTime else { return .notSet }

        let now = Date()
        let endWindow = wakeUpTime.addingTimeInterval(wakeUpWindow)

        if didCheckIn { return .completed }
        if now < wakeUpTime { return .upcoming }
        if now > endWindow { return .missed }

        return .active
    }
}

