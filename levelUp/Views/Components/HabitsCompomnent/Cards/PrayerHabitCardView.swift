//
//  PrayerHabitCardView.swift
//  levelUp
//
//  Created by Jory on 23/08/1447 AH.
//

import SwiftUI

struct PrayerHabitCardView: View {
    var habit: Habit

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            VStack(alignment: .leading) {
                HStack {
                    Text("Prayer")
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()
                }

                Text("Prayer")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }

            HStack {
                Spacer()
                Image(systemName: prayerIcon)
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(habit.type.color)
        .frame(width: 168, height: 146)
        .cornerRadius(16)
    }

    // MARK: - Prayer Icon Logic
    private var prayerIcon: String {
        switch habit.title.lowercased() {
        case "fajr":
            return "sunrise.fill"
        case "dhuhr":
            return "sun.max.fill"
        case "asr":
            return "sun.min.fill"
        case "maghrib":
            return "sunset.fill"
        case "isha":
            return "moon.stars.fill"
        default:
            return "sunrise.fill"
        }
    }
}
//import SwiftUI
//
//struct PrayerHabitCardView: View {
//    var habit: Habit
//    let prayerManager: PrayerManager
//
//    @State private var currentPrayer: Prayer?
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//
//            VStack(alignment: .leading) {
//                HStack {
//                    Text(currentPrayer?.rawValue ?? "Prayer")
//                        .font(.headline)
//                        .foregroundColor(.white)
//
//                    Spacer()
//                }
//
//                Text("Current Prayer")
//                    .font(.subheadline)
//                    .foregroundColor(.white.opacity(0.9))
//            }
//
//            HStack {
//                Spacer()
//                Image(systemName: prayerIcon)
//                    .font(.system(size: 60))
//                    .foregroundColor(.white.opacity(0.7))
//            }
//        }
//        .padding()
//        .background(habit.type.color)
//        .frame(width: 168, height: 146)
//        .cornerRadius(16)
//        .task {
////            await loadCurrentPrayer()
//        }
//    }

    // MARK: - Logic

//    private func loadCurrentPrayer() async {
//        do {
//            currentPrayer = try await prayerManager.
//        } catch {
//            currentPrayer = nil
//        }
//    }

//    private var prayerIcon: String {
//        switch currentPrayer {
//        case .fjr:
//            return "sunrise.fill"
//        case .dhr:
//            return "sun.max.fill"
//        case .asr:
//            return "sun.min.fill"
//        case .mgb:
//            return "sunset.fill"
//        case .ish:
//            return "moon.stars.fill"
//        default:
//            return "sunrise.fill"
//        }
//    }
//}

#Preview {
    PrayerHabitCardView(
        habit: PreviewData.stepsHabit
    )
}

