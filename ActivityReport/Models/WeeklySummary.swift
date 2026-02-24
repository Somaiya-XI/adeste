//
//  WeeklySummary.swift
//  ActivityReport
//
//  Created by Somaiya on 27/08/1447 AH.
//

import Foundation

struct WeeklyActivitySummary: Codable {
    let weeklyTotal: TimeInterval
    let dailyAverage: TimeInterval
    let suggestedDailyTarget: TimeInterval
    let categoryBreakdown: [String: TimeInterval] // category name -> duration
    let lastUpdated: Date
}
