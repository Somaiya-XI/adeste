//
//  PreviewData.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import Foundation

#if DEBUG
enum PreviewData {

    // MARK: - Base Habits

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
    // MARK: - Prayer Habit

    static var prayerHabit: Habit {
        let h = Habit(
            id: UUID().uuidString,
            title: "Prayer",
            type: .prayer,
            isEnabled: true
        )
        return h
    }

    // MARK: - Athkar Habit

    static var athkarHabit: Habit {
        let h = Habit(
            id: UUID().uuidString,
            title: "Athkar",
            type: .athkar,
            isEnabled: true
        )
        return h
    }

    // MARK: - Extra Habits (for paging test)

    static var waterHabit2: Habit {
        let h = Habit(
            id: UUID().uuidString,
            title: "Water Intake 2",
            type: .water,
            isEnabled: true
        )
        h.waterIntake = 1
        return h
    }

    static var stepsHabit2: Habit {
        let h = Habit(
            id: UUID().uuidString,
            title: "Steps 2",
            type: .steps,
            isEnabled: true
        )
        h.stepsCount = 4200
        return h
    }

    static var wakeUpHabit2: Habit {
        let h = Habit(
            id: UUID().uuidString,
            title: "Wake Up 2",
            type: .wakeUp,
            isEnabled: true
        )
        h.wakeUpTime = Calendar.current.date(
            bySettingHour: 6,
            minute: 30,
            second: 0,
            of: Date()
        )
        return h
    }

    // MARK: - Pages

    static var pageOne: [Habit] {
        [wakeUpHabit, stepsHabit, waterHabit]
    }

    static var pageTwo: [Habit] {
        [wakeUpHabit2, stepsHabit2, waterHabit2]
    }

    static var pages: [[Habit]] {
        [pageOne, pageTwo]
    }
}
#endif
