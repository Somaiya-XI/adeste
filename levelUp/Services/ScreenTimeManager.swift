//
//  ScreeTimeManager.swift
//  Adeste
//
//  Created by Somaiya on 21/08/1447 AH.
//

import Foundation
import FamilyControls

@Observable
class ScreenTimeManager {
    var authorizationStatus: FamilyControls.AuthorizationStatus = .notDetermined
    var activitySelection = FamilyActivitySelection()
    
    
    init() {
        // Check initial status if needed when the app starts
        Task {
            await checkAuthorization()
        }
    }
    
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual) // Use .individual for non-Family Sharing apps
            self.authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        } catch {
            // Handle errors appropriately (e.g., logging, showing an alert)
            print("Failed to request authorization: \(error.localizedDescription)")
            self.authorizationStatus = .denied // Or handle specific errors
        }
    }
    
    
    // To make sure of the current permession status
    func checkAuthorization() async {
         self.authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }
}
