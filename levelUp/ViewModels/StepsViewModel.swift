//
//  StepsViewModel.swift
//  adeste
//
//  Created by Jory on 23/08/1447 AH.
//

import Foundation
import Combine

class StepsViewModel: ObservableObject {
    let habit : Habit
    @Published private(set) var stepsCount: Int = 0
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?
    init(habit: Habit) {
        self.habit = habit
        
#if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.stepsCount = 4321
            return
        }
#endif
        
    }
    func fetchSteps() {
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                print("Requesting HealthKit authorization...")
                try await HealthManager.shared.requestAuthorization()
                let steps = try await HealthManager.shared.fetchSteps()
                
                self.stepsCount = steps
                self.isLoading = false
                
            } catch {
                self.errorMessage = "Failed to fetch steps"
                self.isLoading = false
                print("Health error:", error)
            }
        }
    }
    
    func refreshSteps() {
        fetchSteps()
    }
}

