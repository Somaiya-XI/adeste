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
