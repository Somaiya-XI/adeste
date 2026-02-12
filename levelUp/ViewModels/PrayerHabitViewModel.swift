//
//  PrayerHabitViewModel.swift
//  levelUp
//
//  Single source of truth for PrayerHabitCardView. Connects PrayerManager (backend)
//  to the UI via @Published state and async refresh/check-in.
//

import Foundation
import Combine

// #region agent log
private func _agentLogVM(location: String, message: String, hypothesisId: String, errorDesc: String? = nil) {
    let dataStr = errorDesc.map { "\"error\":\"\($0.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))\"" } ?? ""
    let line = "{\"location\":\"\(location)\",\"message\":\"\(message)\",\"data\":{\(dataStr)},\"timestamp\":\(Int(Date().timeIntervalSince1970 * 1000)),\"hypothesisId\":\"\(hypothesisId)\"}\n"
    let path = "/Users/danaalghadeer/Desktop/level-up/.cursor/debug.log"
    guard let d = line.data(using: .utf8) else { return }
    if !FileManager.default.fileExists(atPath: path) { FileManager.default.createFile(atPath: path, contents: d); return }
    guard let h = try? FileHandle(forWritingTo: URL(fileURLWithPath: path)) else { return }
    h.seekToEndOfFile(); h.write(d); try? h.close()
}
// #endregion

@MainActor
final class PrayerHabitViewModel: ObservableObject {

    // MARK: - Published state

    @Published private(set) var isLoading = false
    @Published var alertMessage: String?
    @Published private(set) var todayCompletion = false
    @Published private(set) var checkedPrayers: Set<Prayer> = []
    @Published private(set) var currentPrayer: Prayer?
    @Published private(set) var nextPrayer: Prayer?
    @Published private(set) var canCheck: [Prayer: Bool] = [:]
    @Published private(set) var prayerWindows: [PrayerWindow] = []

    // MARK: - Dependencies

    private let manager: PrayerManager

    // MARK: - Init

    init(manager: PrayerManager) {
        self.manager = manager
        // Initialize canCheck for all prayers so the UI always has a value
        for prayer in Prayer.allCases {
            canCheck[prayer] = false
        }
    }

    // MARK: - Public methods

    /// Loads windows, current/next prayer, checked prayers, canCheck, and today completion.
    /// Call on appear and after check-in. Errors are surfaced as alertMessage.
    func refresh(now: Date = Date()) async {
        // #region agent log
        _agentLogVM(location: "PrayerHabitViewModel.swift:refresh", message: "refresh_started", hypothesisId: "C")
        // #endregion
        isLoading = true
        alertMessage = nil

        do {
            async let windowsTask = manager.todayWindows(now: now)
            async let currentTask = manager.currentPrayer(now: now)
            async let nextTask = manager.nextPrayer(now: now)
            async let checkedTask = manager.checkedPrayersForToday(now: now)
            async let progressTask = manager.progressForToday(now: now)

            let windows = try await windowsTask
            let current = try await currentTask
            let next = try await nextTask
            let checked = try await checkedTask
            let completed = try await progressTask

            prayerWindows = windows
            currentPrayer = current
            nextPrayer = next
            checkedPrayers = checked
            todayCompletion = completed

            var canCheckDict: [Prayer: Bool] = [:]
            for prayer in Prayer.allCases {
                canCheckDict[prayer] = windows.first(where: { $0.prayer == prayer }).map { window in
                    now >= window.start && now < window.end
                } ?? false
            }
            canCheck = canCheckDict
            // #region agent log
            _agentLogVM(location: "PrayerHabitViewModel.swift:refresh", message: "refresh_done", hypothesisId: "C")
            // #endregion

        } catch {
            // #region agent log
            _agentLogVM(location: "PrayerHabitViewModel.swift:refresh", message: "refresh_error", hypothesisId: "C", errorDesc: error.localizedDescription)
            // #endregion
            alertMessage = error.localizedDescription
            // Clear optional state on error so UI doesn’t show stale data
            currentPrayer = nil
            nextPrayer = nil
            checkedPrayers = []
            todayCompletion = false
            canCheck = Dictionary(uniqueKeysWithValues: Prayer.allCases.map { ($0, false) })
            prayerWindows = []
        }

        isLoading = false
    }

    /// Records a check-in for the given prayer. On success refreshes state; on outside-window
    /// or other error sets alertMessage for the user.
    func checkPrayer(_ prayer: Prayer, now: Date = Date()) async {
        isLoading = true
        alertMessage = nil

        do {
            try await manager.checkIn(prayer: prayer, now: now)
            await refresh(now: now)
        } catch {
            alertMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// Call when the user dismisses the alert so you can clear the message.
    func clearAlert() {
        alertMessage = nil
    }
}

// MARK: - Intended usage from a View
//
// In the parent view (e.g. HomeView or the view that hosts the prayer card):
//
//   @StateObject private var prayerVM: PrayerHabitViewModel
//
//   init(manager: PrayerManager) {
//       _prayerVM = StateObject(wrappedValue: PrayerHabitViewModel(manager: manager))
//   }
//
//   var body: some View {
//       PrayerHabitCardView(viewModel: prayerVM, habit: prayerHabit)
//           .onAppear {
//               Task { await prayerVM.refresh() }
//           }
//           .alert("Prayer", isPresented: .constant(prayerVM.alertMessage != nil)) {
//               Button("OK") { prayerVM.clearAlert() }
//           } message: {
//               Text(prayerVM.alertMessage ?? "")
//           }
//   }
//
// Then in PrayerHabitCardView (when you hook it up): take a ViewModel and bind
// prayerVM.todayCompletion, prayerVM.checkedPrayers, prayerVM.currentPrayer,
// prayerVM.nextPrayer, prayerVM.canCheck, and call prayerVM.checkPrayer(_:) on button tap.
