//
//  PreviewData.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import Foundation

#if DEBUG
enum PreviewData {

    static var waterHabit: Habit {
        let h = Habit(
            id: UUID().uuidString,
            title: "Water Intake",
            type: .water,
            isEnabled: true
        )
        h.waterIntake = 3
        return h
    }

    static var stepsHabit: Habit {
        let h = Habit(
            id: UUID().uuidString,
            title: "Steps",
            type: .steps,
            isEnabled: true
        )
        h.stepsCount = 9565
        return h
    }

    static var wakeUpHabit: Habit {
        let h = Habit(
            id: UUID().uuidString,
            title: "Wake Up",
            type: .wakeUp,
            isEnabled: true
        )
        h.wakeUpTime = Calendar.current.date(
            bySettingHour: 7,
            minute: 45,
            second: 0,
            of: Date()
        )
        return h
    }

    static var pageOne: [Habit] {
        [wakeUpHabit, stepsHabit, waterHabit]
    }

    static var pages: [[Habit]] {
        [pageOne]
    }
}
#endif

