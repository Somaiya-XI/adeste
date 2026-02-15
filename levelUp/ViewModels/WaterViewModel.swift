//
//  WaterHabitViewModel.swift
//  adeste
//
//  Created by Jory on 23/08/1447 AH.
//
import Foundation
import Combine

class WaterViewModel: ObservableObject {
    let habit: Habit
    @Published private(set) var waterIntake: Int = 0
    var lastWaterDate: Date?
    var increaseCount: Int = 0
    private(set) var maxCups = 8
    
    private let limit: TimeInterval = 5400
    
    init(habit: Habit) {
        self.habit = habit
    }
    
}
extension WaterViewModel {

    func canIncreaseWater() -> Bool {
        print("can increase water called")
        
        guard waterIntake < maxCups else {
            print("already at max cups")
            return false
        }
        
        let now = Date()
        
        guard let last = lastWaterDate else {
            print("no previous water date - allowing increase")
            return true
        }
        
        // If time limit passed, allow increase (but don't reset here!)
        if now.timeIntervalSince(last) > limit {
            print("time limit passed - allowing increase")
            return true
        }
        
        // Within time limit - check the count
        return increaseCount < 2
    }

    func increaseWater() {
        print("increase water called + current \(waterIntake)")
        
        guard waterIntake < maxCups else {
            print("already at max cups")
            return
        }
        
        let now = Date()
        
        // Check if we need to reset the time window
        if let last = lastWaterDate {
            if now.timeIntervalSince(last) > limit {
                print("time limit passed - resetting counter")
                lastWaterDate = now
                increaseCount = 0
            }
        } else {
            // First time tracking
            lastWaterDate = now
            increaseCount = 0
        }
        
        // Now check if we can actually increase
        guard increaseCount < 2 else {
            print("cannot increase water - limit reached")
            return
        }
        
        waterIntake += 1
        increaseCount += 1
        print("water increased to \(waterIntake)")
    }
    
    
    private func reset(_ date: Date) {
        print("reset called ")
        lastWaterDate = date
        increaseCount = 1
    }
    
    func decreaseWater() {
        print("decrease water called current \(waterIntake)")
        guard waterIntake > 0 else { return }
        print("already at 0")
        waterIntake -= 1
        
    
        if increaseCount > 0 {
            increaseCount -= 1
        }
    }
    
}



