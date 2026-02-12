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
                //               resultPages.append(currentPage)
                //               currentPage = []
                resultPages.append(arrangeHabitsForLayout(currentPage))
                currentPage = []
            }
        }
        if !currentPage.isEmpty {
            resultPages.append(arrangeHabitsForLayout(currentPage))
        }
        
        
        self.pages = resultPages
        
    }
    // Ensures water is always in rectangle position for 3-habit layouts
    private func arrangeHabitsForLayout(_ habits: [Habit]) -> [Habit] {
        guard habits.count == 3 else { return habits }
        
        // Move water to last position (rectangle/bottom)
        if let waterIndex = habits.firstIndex(where: { $0.type == .water }) {
            var arranged = habits
            let water = arranged.remove(at: waterIndex)
            arranged.append(water)  // Water goes last = bottom rectangle
            return arranged
        }
        
        return habits
        
    }
}

