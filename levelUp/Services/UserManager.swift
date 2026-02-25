//
//  UserManager.swift
//  levelUp
//
//  Created by Somaiya on 16/08/1447 AH.
//

import Foundation
import SwiftUI

/// Keys for UserDefaults/AppStorage
enum UserDefaultsKeys {
    static let userData = "userData"
    static let isOnboardingComplete = "isOnboardingComplete"
    static let onboardingStep = "onboardingStep"
}

/// Onboarding steps tracker
enum OnboardingStep: Int, Codable {
    case welcome = 0
    case enterName = 1
    case selectCycle = 2
    case selectHabits = 3
    case setupScreenTime = 4
    case completed = 5
}

/// Observable UserManager for managing user state across the app
@Observable
class UserManager {
    
    // MARK: - Singleton
    static let shared = UserManager()
    
    // MARK: - Published Properties
    var currentUser: User?
    var isOnboardingComplete: Bool = false
    var currentOnboardingStep: OnboardingStep = .welcome
    
    // MARK: - Private
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Init
    private init() {
        loadUser()
        loadOnboardingState()
    }
    
    // MARK: - User Management
    
    /// Load user from UserDefaults
    func loadUser() {
        guard let data = userDefaults.data(forKey: UserDefaultsKeys.userData),
              let user = try? decoder.decode(User.self, from: data) else {
            currentUser = nil
            return
        }
        currentUser = user
    }
    
    /// Save user to UserDefaults
    func saveUser() {
        guard let user = currentUser,
              let data = try? encoder.encode(user) else {
            return
        }
        userDefaults.set(data, forKey: UserDefaultsKeys.userData)
    }
    
    /// Create a new user (first time)
    func createUser(name: String) {
        let newUser = User(
            name: name,
            currentCycleId: "",
            streak: 0,
            habits: []
        )
        currentUser = newUser
        saveUser()
    }
    
    /// Update user name
    func updateName(_ name: String) {
        currentUser?.name = name
        saveUser()
    }
    
    /// Update user's current cycle
    func updateCycle(_ cycleId: String) {
        currentUser?.currentCycleId = cycleId
        saveUser()
    }
    
    /// Update user's habits
    func updateHabits(_ habits: [Habit]) {
        currentUser?.habits = habits
        saveUser()
    }
    
    // MARK: - Onboarding Management
    
    /// Load onboarding state
    func loadOnboardingState() {
        isOnboardingComplete = userDefaults.bool(forKey: UserDefaultsKeys.isOnboardingComplete)
        let stepRaw = userDefaults.integer(forKey: UserDefaultsKeys.onboardingStep)
        currentOnboardingStep = OnboardingStep(rawValue: stepRaw) ?? .welcome
    }
    
    /// Save current onboarding step
    func setOnboardingStep(_ step: OnboardingStep) {
        currentOnboardingStep = step
        userDefaults.set(step.rawValue, forKey: UserDefaultsKeys.onboardingStep)
    }
    
    /// Mark onboarding as complete
    func completeOnboarding() {
        isOnboardingComplete = true
        currentOnboardingStep = .completed
        userDefaults.set(true, forKey: UserDefaultsKeys.isOnboardingComplete)
        userDefaults.set(OnboardingStep.completed.rawValue, forKey: UserDefaultsKeys.onboardingStep)
    }
    
    /// Reset onboarding (for testing)
    func resetOnboarding() {
        isOnboardingComplete = false
        currentOnboardingStep = .welcome
        userDefaults.set(false, forKey: UserDefaultsKeys.isOnboardingComplete)
        userDefaults.set(OnboardingStep.welcome.rawValue, forKey: UserDefaultsKeys.onboardingStep)
    }
    
    /// Clear all user data (for testing/logout)
    func clearAllData() {
        currentUser = nil
        userDefaults.removeObject(forKey: UserDefaultsKeys.userData)
        resetOnboarding()
    }
    
    // MARK: - Computed Properties
    
    var hasUser: Bool {
        return currentUser != nil
    }
    
    var userName: String {
        return currentUser?.name ?? ""
    }
    
    var userStreak: Int {
        return currentUser?.streak ?? 0
    }
}

// MARK: - Environment Key for SwiftUI
struct UserManagerKey: EnvironmentKey {
    static let defaultValue = UserManager.shared
}

extension EnvironmentValues {
    var userManager: UserManager {
        get { self[UserManagerKey.self] }
        set { self[UserManagerKey.self] = newValue }
    }
}

