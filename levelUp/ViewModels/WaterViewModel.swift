
import Foundation
import Combine

class WaterViewModel: ObservableObject {
    let habit: Habit
    @Published private(set) var waterIntake: Int = 0 {
        didSet { UserDefaults.standard.set(waterIntake, forKey: storageKey("waterIntake")) }
    }
    
    var lastWaterDate: Date? {
        didSet {
            if let date = lastWaterDate {
                UserDefaults.standard.set(date, forKey: storageKey("lastWaterDate"))
            } else {
                UserDefaults.standard.removeObject(forKey: storageKey("lastWaterDate"))
            }
            UserDefaults.standard.synchronize()
        }
    }

    var increaseCount: Int = 0 {
        didSet {
            UserDefaults.standard.set(increaseCount, forKey: storageKey("increaseCount"))
            UserDefaults.standard.synchronize()
        }
    }
    private(set) var maxCups = 8
    private let limit: TimeInterval = 5400
    
    private func storageKey(_ field: String) -> String {
        "water_\(habit.id)_\(field)"
    }
    
    init(habit: Habit) {
        self.habit = habit
        loadFromStorage()
    }
    
    private func loadFromStorage() {
        let savedIntake = UserDefaults.standard.integer(forKey: storageKey("waterIntake"))
        let savedCount  = UserDefaults.standard.integer(forKey: storageKey("increaseCount"))
        let savedDate   = UserDefaults.standard.object(forKey: storageKey("lastWaterDate")) as? Date
        let savedDay    = UserDefaults.standard.object(forKey: storageKey("lastSavedDay")) as? Date

        if let savedDay, !Calendar.current.isDateInToday(savedDay) {
            waterIntake   = 0
            increaseCount = 0
            lastWaterDate = nil
            UserDefaults.standard.removeObject(forKey: storageKey("lastWaterDate"))
        } else {
            waterIntake   = savedIntake
            increaseCount = savedCount
            lastWaterDate = savedDate
        }
        
        UserDefaults.standard.set(Date(), forKey: storageKey("lastSavedDay"))
    }
}

extension WaterViewModel {

    func canIncreaseWater() -> Bool {
        guard waterIntake < maxCups else { return false }
        let now = Date()
        guard let last = lastWaterDate else { return true }
        if now.timeIntervalSince(last) > limit { return true }
        return increaseCount < 2
    }

    func increaseWater() {
        guard waterIntake < maxCups else { return }
        let now = Date()
        if let last = lastWaterDate {
            if now.timeIntervalSince(last) > limit {
                lastWaterDate = now
                increaseCount = 0
            }
        } else {
            lastWaterDate = now
            increaseCount = 0
        }
        guard increaseCount < 2 else { return }
        waterIntake += 1
        increaseCount += 1
    }

    func decreaseWater() {
        guard waterIntake > 0 else { return }
        waterIntake -= 1
        if increaseCount > 0 {
            increaseCount -= 1
        }
    }

    private func reset(_ date: Date) {
        lastWaterDate = date
        increaseCount = 1
    }
}
