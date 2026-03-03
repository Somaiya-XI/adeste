import SwiftUI

struct GoalChangeTracker {
    private static let defaults = UserDefaults.standard
    
    // MARK: Keys
    private static func wakeUpKey(cycleId: String) -> String { "goalChanges_wakeUp_\(cycleId)" }
    private static func stepsKey(cycleId: String)  -> String { "goalChanges_steps_\(cycleId)" }
    
    // MARK: Max allowed changes per cycle type
    static func maxChanges(for cycleType: CycleType) -> Int {
        switch cycleType {
        case .starter:  return 2  // Awareness
        case .basic:    return 3   // Consistency
        case .advanced: return 4  // Foundation
        case .premium:  return 5  // Growth – same as Foundation (adjust if needed)
        }
    }
    
    // MARK: Read counts
    static func wakeUpChanges(cycleId: String) -> Int {
        defaults.integer(forKey: wakeUpKey(cycleId: cycleId))
    }
    
    static func stepsChanges(cycleId: String) -> Int {
        defaults.integer(forKey: stepsKey(cycleId: cycleId))
    }
    
    // MARK: Increment
    static func incrementWakeUp(cycleId: String) {
        let current = wakeUpChanges(cycleId: cycleId)
        defaults.set(current + 1, forKey: wakeUpKey(cycleId: cycleId))
    }
    
    static func incrementSteps(cycleId: String) {
        let current = stepsChanges(cycleId: cycleId)
        defaults.set(current + 1, forKey: stepsKey(cycleId: cycleId))
    }
    
    // MARK: Limit checks
    static func canChangeWakeUp(cycleId: String, cycleType: CycleType) -> Bool {
        wakeUpChanges(cycleId: cycleId) < maxChanges(for: cycleType)
    }
    
    static func canChangeSteps(cycleId: String, cycleType: CycleType) -> Bool {
        stepsChanges(cycleId: cycleId) < maxChanges(for: cycleType)
    }
}

// MARK: - Main Sheet View

struct HabitsGoalSheet: View {
    let selectedHabits: Set<String>
    
    @Binding var selectedWakeUpTime: Date
    @Binding var stepGoal: Int
    let isOnboarding: Bool
    
    @Environment(\.dismiss) var dismiss
    
    private let stepOptions = [5000, 6000, 7000, 8000, 10000, 12000, 15000]
    
    // Pull cycle info from UserManager
    private var cycleId: String   { UserManager.shared.currentUser?.currentCycleId ?? "" }
    
    let cycleType: CycleType
    
    // MARK: Convenience flags
    var showWakeUp: Bool { selectedHabits.contains("Wake Up") }
    var showSteps:  Bool { selectedHabits.contains("Walk") }
    
    private var canEditWakeUp: Bool {
        GoalChangeTracker.canChangeWakeUp(cycleId: cycleId, cycleType: cycleType)
    }
    private var canEditSteps: Bool {
        GoalChangeTracker.canChangeSteps(cycleId: cycleId, cycleType: cycleType)
    }
    
    private var maxChanges: Int {
        GoalChangeTracker.maxChanges(for: cycleType)
    }
    
    // True only when every visible habit has hit its limit
    private var allLimitsReached: Bool {
        let wakeUpBlocked = showWakeUp && !canEditWakeUp
        let stepsBlocked  = showSteps  && !canEditSteps
        let anyVisible    = showWakeUp || showSteps
        
        if !anyVisible { return false }
        if showWakeUp && showSteps { return wakeUpBlocked && stepsBlocked }
        if showWakeUp { return wakeUpBlocked }
        return stepsBlocked
    }
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            
            // Drag handle
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 12)
            
            // Header
            Text("Set your goals")
                .font(.s32Bold)
                .foregroundColor(Color("brand-color"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 28)
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    
                    if allLimitsReached {
                        // ── Empty state ──────────────────────────────────────
                        emptyLimitView
                    } else {
                        // ── Wake Up card ─────────────────────────────────────
                        if showWakeUp {
                            if canEditWakeUp {
                                GoalSectionCard(title: "Wake Up Time", icon: "sun.max.fill") {
                                    VStack(spacing: 8) {
                                        changesRemainingBadge(
                                            used: GoalChangeTracker.wakeUpChanges(cycleId: cycleId),
                                            max: maxChanges
                                        )
                                        DatePicker(
                                            "Wake up",
                                            selection: $selectedWakeUpTime,
                                            displayedComponents: .hourAndMinute
                                        )
                                        .datePickerStyle(.wheel)
                                        .labelsHidden()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 150)
                                        .clipped()
                                    }
                                }
                            } else {
                                lockedCard(title: "Wake Up Time", icon: "sun.max.fill")
                            }
                        }
                        
                        // ── Steps card ───────────────────────────────────────
                        if showSteps {
                            if canEditSteps {
                                GoalSectionCard(title: "Daily Step Goal", icon: "figure.walk.motion") {
                                    VStack(spacing: 8) {
                                        changesRemainingBadge(
                                            used: GoalChangeTracker.stepsChanges(cycleId: cycleId),
                                            max: maxChanges
                                        )
                                        Text("\(stepGoal) steps")
                                            .font(.s28Medium)
                                            .foregroundColor(Color("brand-color"))
                                        Picker("Steps", selection: $stepGoal) {
                                            ForEach(stepOptions, id: \.self) { steps in
                                                Text("\(steps)")
                                                    .font(.s24Medium)
                                                    .tag(steps)
                                            }
                                        }
                                        .pickerStyle(.wheel)
                                        .frame(height: 150)
                                        .clipped()
                                    }
                                }
                            } else {
                                lockedCard(title: "Daily Step Goal", icon: "figure.walk.motion")
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            
            // Save button – hidden when everything is locked
            if !allLimitsReached {
                Button(action: saveGoals) {
                    Text("Save Goals")
                        .font(.s28Medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color("brand-color"))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            } else {
                Button(action: { dismiss() }) {
                    Text("Close")
                        .font(.s28Medium)
                        .foregroundColor(Color("brand-color"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color("brand-color").opacity(0.1))
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Color.white)
    }
    
    // MARK: - Save Logic
    
    private func saveGoals() {
        if showWakeUp && canEditWakeUp {
            AppHabitWakeUpManager.shared.updateTargetTime(to: selectedWakeUpTime)
            if !isOnboarding {
                GoalChangeTracker.incrementWakeUp(cycleId: cycleId)
            }
        }
        if showSteps && canEditSteps {
            UserDefaults.standard.set(stepGoal, forKey: "saved_step_goal")
            if !isOnboarding {
                GoalChangeTracker.incrementSteps(cycleId: cycleId)
            }
        }
        dismiss()
    }
    // MARK: - Sub-views
    
    /// Small pill showing "X changes left"
    @ViewBuilder
    private func changesRemainingBadge(used: Int, max: Int) -> some View {
        let remaining = max - used
        HStack(spacing: 4) {
            Image(systemName: remaining == 1 ? "exclamationmark.circle.fill" : "arrow.triangle.2.circlepath")
                .font(.system(size: 12, weight: .semibold))
            Text(remaining == 1
                 ? "Last change allowed this cycle"
                 : "\(remaining) changes remaining this cycle")
            .font(.caption)
            .fontWeight(.medium)
        }
        .foregroundColor(remaining == 1 ? .orange : Color("brand-color"))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            (remaining == 1 ? Color.orange : Color("brand-color")).opacity(0.1)
        )
        .cornerRadius(20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Card shown when the limit for a specific habit is reached
    @ViewBuilder
    private func lockedCard(title: String, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.gray.opacity(0.5))
                Text(title)
                    .font(.s24Medium)
                    .foregroundColor(Color.gray.opacity(0.5))
            }
            HStack(spacing: 8) {
                Image(systemName: "lock.fill")
                    .foregroundColor(.orange)
                Text("You've used all \(maxChanges) goal change\(maxChanges == 1 ? "" : "s") allowed for the \(cycleType.rawValue) cycle.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("base-shade-01"))
        .cornerRadius(20)
        .opacity(0.7)
    }
    
    /// Full empty state when ALL selected habits are locked
    @ViewBuilder
    private var emptyLimitView: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(.orange.opacity(0.8))
            
            Text("Goal changes locked")
                .font(.s24Medium)
                .foregroundColor(Color("brand-color"))
            
            Text("You've reached the \(maxChanges) change limit for the **\(cycleType.rawValue)** cycle.\n\nYour goals will unlock again when you start a new cycle.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - GoalSectionCard (unchanged)

struct GoalSectionCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("brand-color"))
                Text(title)
                    .font(.s24Medium)
                    .foregroundColor(Color("brand-color"))
            }
            content()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("base-shade-01"))
        .cornerRadius(20)
    }
}
#Preview {
    HabitsGoalSheet(
        selectedHabits: ["Wake Up", "Walk"],
        selectedWakeUpTime: .constant(Date()),
        stepGoal: .constant(8000),
        isOnboarding: false,
        cycleType: .basic  
    )
}
