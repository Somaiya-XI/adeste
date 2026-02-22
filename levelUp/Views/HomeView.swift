////
////  HomeView.swift
////  levelUp
////
////  Created by Somaiya on 20/08/1447 AH.
////
//
//
import SwiftUI

struct HomeView: View {
    @State private var userManager = UserManager.shared
    
    let prayerManager = PrayerManager(
        timesProvider: AdhanPrayerTimesProvider(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        store: UserDefaultsPrayerStore()
    )
    let athkarManager = AthkarManager(
        timesProvider: AdhanPrayerTimesProvider(
            latitude: 24.7136,
            longitude: 46.6753
        ),
        store: UserDefaultsAthkarStore()
    )
    
    
    init(previewPages: [[Habit]]? = nil, cycle: Cycle) {
        self.cycle = cycle
        let vm = HomeViewModel()
        if let previewPages {
            vm.pages = previewPages
        }
        _viewModel = StateObject(wrappedValue: vm)
        
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.brand)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.brand.opacity(0.3))
    }
    
    @StateObject private var viewModel = HomeViewModel()
    @State private var hasLoadedHabits = false
    
    var body: some View {
        VStack(spacing: 24) {
            VStack{
                StreakView()
                    MapSectionView(cycle: Cycle(
                        cycleType: .starter, cycleDuration: .starter
                    ))
                    AppLimitCardView()
                    
                    HabitsSectionView(
                        pages: viewModel.pages,
                        prayerManager: prayerManager,
                        athkarManager: athkarManager
                    )
                
            }.padding(.horizontal)
           
            
            Spacer()
        }
        .onAppear {
            // Load user's selected habits only once
            if !hasLoadedHabits, let habits = userManager.currentUser?.habits {
                viewModel.loadHabits(habits)
                hasLoadedHabits = true
            }
            
            // TODO: Move this to onboarding later
            requestHealthKitPermission()
        }
    }
 
    private func requestHealthKitPermission() {
        Task {
            do {
                print("🔍 Requesting HealthKit permission from HomeView...")
                try await HealthManager.shared.requestAuthorization()
                print("✅ HealthKit permission granted!")
            } catch {
                print("❌ HealthKit permission failed: \(error)")
            }
        }
    }
}
#Preview("HomeView – Mock Data") {
    // Create a sample cycle
       let cycle = Cycle(id: "1", cycleType: .Basic, cycleDuration: .basic)
       
    let page1: [Habit] = [
        Habit(title: "Water", type: .water),
        Habit(title: "Steps", type: .steps),
        Habit(title: "Wake Up", type: .wakeUp)
    ]
    
    let page2: [Habit] = [
        Habit(title: "Prayer", type: .prayer),
        Habit(title: "Water", type: .water),
    ]
    let page3: [Habit] = [
        Habit(title: "athkar ", type: .athkar),
    ]
    
    HomeView(previewPages: [page1, page2, page3],cycle: cycle)
}



