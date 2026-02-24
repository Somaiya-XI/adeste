
//  AthkarViewModel.swift
//  levelUp
//
//  Athkar habit view model
//

import Foundation
import Combine

class AthkarViewModel: ObservableObject {
    let habit: Habit
    
    @Published private(set) var currentPeriod: AthkarPeriod = .morning
    @Published private(set) var isCheckedIn: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let athkarManager: AthkarManager
    private var cancellables = Set<AnyCancellable>()
    
    init(habit: Habit, athkarManager: AthkarManager) {
        self.habit = habit
        self.athkarManager = athkarManager
        
        // Start monitoring current period
        Task {
            await updateCurrentPeriod()
        }
    }
    
    // Determine if it's morning or evening athkar time
    @MainActor
    func updateCurrentPeriod() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let now = Date()
            
            // Get current period from manager
            if let period = try await athkarManager.currentPeriod(now: now) {
                currentPeriod = period
            } else {
                // Default to morning if outside both windows
                currentPeriod = .morning
            }
            
            // Check if current period is already checked in
            await checkIfCheckedIn()
            
        } catch {
            print("❌ Error loading athkar period: \(error)")
            errorMessage = "Failed to load athkar times"
        }
    }
    
    @MainActor
    private func checkIfCheckedIn() async {
        do {
            let now = Date()
            let dayStart = Calendar.current.startOfDay(for: now)
            let checkIns = try athkarManager.store.load(for: dayStart)
            
            isCheckedIn = checkIns.contains { $0.period == currentPeriod }
        } catch {
            print("❌ Error checking athkar status: \(error)")
        }
    }
    
    // User taps check-in button
    @MainActor
    func checkIn() async {
        do {
            try await athkarManager.checkIn(period: currentPeriod)
            isCheckedIn = true
            errorMessage = nil
            print("✅ Checked in for \(currentPeriod.rawValue) athkar")
        } catch let error as AthkarCheckInError {
            errorMessage = error.errorDescription
            print("❌ Check-in failed: \(error.errorDescription ?? "Unknown error")")
        } catch {
            errorMessage = "Failed to check in"
            print("❌ Check-in failed: \(error)")
        }
    }
    
    // Check if user can check in now
    func canCheckIn() async -> Bool {
        do {
            let now = Date()
            let windows = try await athkarManager.windowsForToday(now: now)
            return athkarManager.windowService.isValidCheckIn(
                period: currentPeriod,
                at: now,
                windows: windows
            )
        } catch {
            return false
        }
    }
}

// Extension to get athkar period info
extension AthkarPeriod {
    var displayName: String {
        switch self {
        case .morning: return "Morning"
        case .evening: return "Evening"
        }
    }
    
    var iconName: String {
        switch self {
        case .morning: return "cloud.sun.fill"
        case .evening: return "cloud.moon.fill"
        }
    }
    
    var backgroundColor: String {
        switch self {
        case .morning: return "sec-color-mustard"  // Yellow
        case .evening: return "sec-color-blue"     // Blue
        }
    }
    
    var textColor: String {
        switch self {
        case .morning: return "brand-color"  // Dark text for yellow background
        case .evening: return "white"        // White text for blue background
        }
    }
}
