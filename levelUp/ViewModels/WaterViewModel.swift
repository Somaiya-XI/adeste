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
       @Published var waterIntake: Int = 0
     var lastWaterDate: Date?
      var increaseCount: Int = 0
     let maxCups = 8

    private let limit: TimeInterval = 5400
    
    init(habit: Habit) {
           self.habit = habit
       }
    
}
extension WaterViewModel {

    func canIncreaseWater() -> Bool {
        print("can increase water called ")
        let now = Date()

        guard let last = lastWaterDate else {
            print("no previous water date= allowing increase ")
            lastWaterDate = now
            increaseCount = 0
            return true
        }

        if now.timeIntervalSince(last) > limit {
            print("time limmit passed- allowing increase ")
            lastWaterDate = now
            increaseCount = 0
            return true
        }

        return increaseCount < 2
    }


    func increaseWater() {
        print(" increase water called+ current \(waterIntake) ")
        guard waterIntake < maxCups else {
            print("already at max cups")
            return }
        guard canIncreaseWater() else {
            print("cannot increase water limit reached ")
            return }
        waterIntake += 1
        increaseCount += 1
        print("water increased to \(waterIntake) ")
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
        
        // نعدل العداد عشان ما يكسر منطق ال limit
        if increaseCount > 0 {
            increaseCount -= 1
        }
    }

}



