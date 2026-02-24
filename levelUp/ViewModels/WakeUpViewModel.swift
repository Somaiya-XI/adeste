//
//  WakeUpViewModel.swift
//  adeste
//
//  Created by Jory on 23/08/1447 AH.
//

import Foundation
import Combine
import SwiftUI


class WakeUpViewModel: ObservableObject{
    let habit: Habit
    
    @Published var wakeUpTime: Date         // 07:00
  
     var wakeUpWindow: TimeInterval = 1800 // 30 دقيقة
 
   @Published private(set) var didCheckIn: Bool = false
 
    @Published var checkInDate: Date? = nil
    

    
    func canCheckIn() -> Bool {
        print("can check in called ")
        guard !didCheckIn else {
            print("already checked in")
            return false }

        let now = Date()
        let window = wakeUpTime ... wakeUpTime.addingTimeInterval(wakeUpWindow)
        print("⏰ Wake up time: \(wakeUpTime), Now: \(now), Can check in: the time they choose")
        return window.contains(now)
    }


       func checkIn() {
           print("check in called")
           guard canCheckIn() else {
               print ("cannot check in")
               return }
           didCheckIn = true
           checkInDate = Date()
           print ("checked in at \(checkInDate!)")
       }

    var status: WakeUpStatus {
        let now = Date()
        let endWindow = wakeUpTime.addingTimeInterval(wakeUpWindow)

        if didCheckIn {
            print ("status is completed")
            return .completed }
        if now < wakeUpTime {
            print("status is upcoming")
            return .upcoming }
        return now <= endWindow ? .upcoming : .missed
    }


    
    
    init(habit: Habit, wakeUpTime: Date) {
        self.habit = habit
        self.wakeUpTime = wakeUpTime
    }

   //for the progress
    enum WakeUpStatus {
        case upcoming
        case completed
        case missed
    }
}
