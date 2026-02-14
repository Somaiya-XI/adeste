//
//  HomeView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//


import SwiftUI

struct HomeView: View {
    init(previewPages: [[Habit]]? = nil) {
        let vm = HomeViewModel()
        if let previewPages {
            vm.pages = previewPages
        }
        _viewModel = StateObject(wrappedValue: vm)
       
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.brand)
          UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.brand.opacity(0.3))
    }

    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: 24) {

            StreakView()
            MapSectionView()
            AppLimitCardView()

            HabitsSectionView()

            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview("HomeView – Mock Data") {

    let page1: [Habit] = [
        Habit(title: "Water", type: .water),
        Habit(title: "Steps", type: .steps),
        Habit(title: "Wake Up", type: .wakeUp)
    ]

    let page2: [Habit] = [
//        Habit(title: "Water", type: .water)
//        Habit(title: "Athkar صباح", type: .athkar)
        Habit(title: "Wake Up", type: .wakeUp),
        Habit(title: "Water", type: .water),
    ]
    let page3: [Habit] = [
//        Habit(title: "Water", type: .water)
//        Habit(title: "Athkar صباح", type: .athkar)
       
        Habit(title: "Water", type: .water),
    ]

    HomeView(previewPages: [page1, page2, page3])
}



