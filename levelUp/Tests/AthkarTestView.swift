//
//  Untitled.swift
//  levelUp
//
//  Created by Dana AlGhadeer on 10/02/2026.
//

import SwiftUI

struct AthkarTestView: View {
    let manager: AthkarManager

    @State private var message = "Tap a button"
    @State private var completed = false

    var body: some View {
        VStack(spacing: 16) {

            Text("Athkar Logic Test")
                .font(.s24Semibold)

            Button("Check Morning Athkar (valid)") {
                Task { await checkMorningValid() }
            }

            Button("Check Evening Athkar (valid)") {
                Task { await checkEveningValid() }
            }

            Button("Check Morning Athkar (INVALID time)") {
                Task { await checkMorningInvalid() }
            }

            Divider()

            Button("Check Progress") {
                Task {
                    do {
                        completed = try await manager.progressForToday().isCompleted
                        message = completed ? "✅ COMPLETED (at least one)" : "❌ NOT COMPLETED"
                    } catch {
                        message = error.localizedDescription
                    }
                }
            }

            Text(message)
                .foregroundColor(completed ? .green : .red)

            Spacer()
        }
        .padding()
    }

    // MARK: - Helpers

    private func checkMorningValid() async {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let validTime = cal.date(bySettingHour: 9, minute: 0, second: 0, of: today)! // within Fajr→Asr

        do {
            try await manager.checkIn(period: .morning, now: validTime)
            message = "✅ Morning checked"
        } catch {
            message = error.localizedDescription
        }
    }

    private func checkEveningValid() async {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let validTime = cal.date(bySettingHour: 20, minute: 0, second: 0, of: today)! // within Asr→Fajr

        do {
            try await manager.checkIn(period: .evening, now: validTime)
            message = "✅ Evening checked"
        } catch {
            message = error.localizedDescription
        }
    }

    private func checkMorningInvalid() async {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let invalidTime = cal.date(bySettingHour: 21, minute: 0, second: 0, of: today)! // evening window

        do {
            try await manager.checkIn(period: .morning, now: invalidTime)
            message = "Should NOT succeed"
        } catch {
            message = "✅ Correctly blocked: \(error.localizedDescription)"
        }
    }
}
