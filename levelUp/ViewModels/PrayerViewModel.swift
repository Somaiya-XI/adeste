//
//  PrayerViewModel.swift
//  levelUp
//
//  Prayer habit view model
//

import Foundation
import Combine
import Adhan

class PrayerViewModel: ObservableObject {
    let habit: Habit
    
    @Published private(set) var currentPrayer: Prayer = .fjr
    @Published private(set) var currentPrayerTime: Date?
    @Published private(set) var nextPrayerTime: Date?
    @Published private(set) var isCheckedIn: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let prayerManager: PrayerManager
    private var cancellables = Set<AnyCancellable>()
    
    init(habit: Habit, latitude: Double = 24.7136, longitude: Double = 46.6753) {
        self.habit = habit
        
        // Initialize PrayerManager with Riyadh coordinates (adjust as needed)
        let provider = AdhanPrayerTimesProvider(
            latitude: latitude,
            longitude: longitude,
            calculationMethod: .ummAlQura,  // ← Change this
            madhab: .shafi
        )
        let store = UserDefaultsPrayerStore()
        self.prayerManager = PrayerManager(
            timesProvider: provider,
            store: store
        )
        
        // Start monitoring prayers
        Task {
            await updateCurrentPrayer()
        }
    }
    
    // Determine which prayer is active now
    @MainActor
    func updateCurrentPrayer() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let now = Date()
            let dayStart = Calendar.current.startOfDay(for: now)
            let times = try await prayerManager.timesProvider.prayerTimes(for: dayStart)
            
            // Find current prayer based on time
            let prayerOrder: [Prayer] = [.fjr, .dhr, .asr, .mgb, .ish]
            var foundPrayer: Prayer = .fjr
            
            for prayer in prayerOrder {
                if let prayerTime = times.times[prayer], now >= prayerTime {
                    foundPrayer = prayer
                    currentPrayerTime = prayerTime
                } else {
                    // This is the next prayer
                    nextPrayerTime = times.times[prayer]
                    break
                }
            }
            
            currentPrayer = foundPrayer
            
            // Check if current prayer is checked in
            await checkIfCheckedIn()
            
        } catch {
            print("❌ Error loading prayer times: \(error)")
            errorMessage = "Failed to load prayer times"
        }
    }
    
    @MainActor
    private func checkIfCheckedIn() async {
        do {
            let now = Date()
            let dayStart = Calendar.current.startOfDay(for: now)
            let checkIns = try prayerManager.store.load(for: dayStart)
            
            isCheckedIn = checkIns.contains { $0.prayer == currentPrayer }
        } catch {
            print("❌ Error checking prayer status: \(error)")
        }
    }
    
    // User taps check-in button
    @MainActor
    func checkIn() async {
        do {
            try await prayerManager.checkIn(prayer: currentPrayer)
            isCheckedIn = true
            errorMessage = nil
            print("✅ Checked in for \(currentPrayer.rawValue)")
        } catch let error as PrayerCheckInError {
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
            return try await prayerManager.canCheckIn(prayer: currentPrayer)
        } catch {
            return false
        }
    }
}

// Extension to get prayer info
extension Prayer {
    var displayName: String {
        self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .fjr: return "sunrise.fill"
        case .dhr: return "sun.max.fill"
        case .asr: return "sun.min.fill"
        case .mgb: return "sunset.fill"
        case .ish: return "moon.stars.fill"
        }
    }
}
