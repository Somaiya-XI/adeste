//
//  HomeView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI


//let mockHabits: [Habit] = {
//    let h1 = Habit(
//        id: UUID().uuidString,
//        title: "Wake Up",
//        type: .wakeUp,
//        isEnabled: true
//    )
//
//    let h2 = Habit(
//        id: UUID().uuidString,
//        title: "Steps",
//        type: .steps,
//        isEnabled: true
//    )
//
//    let h3 = Habit(
//        id: UUID().uuidString,
//        title: "Water Intake",
//        type: .water,
//        isEnabled: true
//    )
//
//    let h4 = Habit(
//        id: UUID().uuidString,
//        title: "Athkar",
//        type: .wakeUp, // أو سوي type جديد لو حابة
//        isEnabled: true
//    )
//
//    return [h1, h2, h3, h4]
//}()

import SwiftUI

struct HomeView: View {
    init(previewPages: [[Habit]]? = nil) {
        let vm = HomeViewModel()
        if let previewPages {
            vm.pages = previewPages
        }
        _viewModel = StateObject(wrappedValue: vm)
    }

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 24) {

            StreakView()
            MapSectionView()
            AppLimitCardView()

            HabitsSectionView(pages: viewModel.pages)

            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
//            viewModel.loadHabits(mockHabits)
        }
    }
}

#Preview {
    HomeView(previewPages: PreviewData.pages)
}


