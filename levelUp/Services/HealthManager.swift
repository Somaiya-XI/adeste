//
//  HealthManager.swift
//  levelUp
//
//  Created by Jory on 21/08/1447 AH.
//

import Foundation
import HealthKit

final class HealthManager {
    static let shared = HealthManager()
    private let healthStore = HKHealthStore()

    private init() {}
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }

        try await healthStore.requestAuthorization(
            toShare: [],
            read: [stepType]
        )
    }

    func fetchSteps() async throws -> Int {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw NSError(domain: "HealthManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Step count type unavailable"])
        }
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let now = Date()
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: stepType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                // Safely unwrap the sum quantity before calling doubleValue
                if let quantity = result?.sumQuantity() {
                    let steps = quantity.doubleValue(for: .count())
                    continuation.resume(returning: Int(steps))
                } else {
                    continuation.resume(returning: 0)
                }
            }
            self.healthStore.execute(query)
        }
    }
}
