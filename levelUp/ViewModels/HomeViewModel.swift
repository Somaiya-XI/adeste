//
//  HomeViewModel.swift
//  levelUp
//
//  Created by Jory on 21/08/1447 AH.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var pages: [[Habit]] = []
    
    func loadHabits(_ habits: [Habit]) {
        let enabledHabits = habits.filter{ $0.isEnabled }
        var resultPages: [[Habit]] = []
        var currentPage: [Habit] = []

       for habit in enabledHabits {
            currentPage.append(habit)
           
           if currentPage.count == 3 {
               resultPages.append(currentPage)
               currentPage = []
           }
        }
        if !currentPage.isEmpty {
            resultPages.append(currentPage)
        }
        

        self.pages = resultPages

        }
    func updateSteps(){
        Task {
            do{
                try await HealthManager.shared.requestAuthorization()
                let steps = try await HealthManager.shared.fetchSteps()
                
                updateStepsHabit(with: steps)
                
            }catch {
                print("health error", error)
            }
        }
        
    }
   
    private func updateStepsHabit(with steps: Int) {
        for page in pages {
            for habit in page where habit.type == .steps {
                habit.stepsCount = steps
            }
        }
    }
    
    func increaseWater() {
        for page in pages {
            for habit in page where habit.type == .water {
                if habit.waterIntake < 8 {
                    habit.waterIntake += 1
                }
            }
        }
    }

    func decreaseWater() {
        for page in pages {
            for habit in page where habit.type == .water {
                if habit.waterIntake > 0 {
                    habit.waterIntake -= 1
                }
            }
        }
    }
    
    
    }


