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
    
    init(id: String, title: String)  {
        self.id = id
        self.title = title
    }
}

// General Structure for Habit Managements
protocol HabitManager  {
    var id: String { get set }
    var name: String { get set }
    
    func calculateHabitProgress() -> HabitProgress
}

struct HabitProgress {
    /// 0.0 → 1.0
    let fraction: Double
    let isCompleted: Bool
}


struct StepsManager: HabitManager {
    var id: String
    var name: String
    func calculateHabitProgress() -> HabitProgress {
        //Custom for each habit
        return HabitProgress(fraction: 0, isCompleted: false)
    }
    
    var stepCount: Int
    var isCompleted: Bool
    

}

struct WaterManager: HabitManager {
    var id: String
    var name: String
    func calculateHabitProgress() -> HabitProgress {
        //Custom for each habit
        return HabitProgress(fraction: 0, isCompleted: false)
    }
    var waterCount: Int
    var isCompleted: Bool

}

enum Prayer: String, CaseIterable, Codable, Hashable {
    case fjr = "Fajr"
    case dhr = "Dhuhr"
    case asr = "Asr"
    case mgb = "Magrib"
    case ish = "Isha"
}

struct PrayerTimesDay {
    // start of the day in user's timezone
    let dayStart: Date

    // prayer times
    let times: [Prayer: Date]
}

import Foundation

protocol PrayerTimesProviding {
    func prayerTimes(for dayStart: Date) async throws -> PrayerTimesDay
}

//struct PrayerManager: HabitManager {
//    var id: String
//    var name: Prayer
//    func calculateHabitProgress() -> HabitProgress {
//        return HabitProgress(fraction: 0, isCompleted: false)
//    }
//}


