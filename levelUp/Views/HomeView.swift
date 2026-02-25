//
//  HomeView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//
//
//
import SwiftUI

struct HomeView: View {
    @State private var userManager = UserManager.shared
    @StateObject private var toastCenter = AppToastCenter.shared
    
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
    
    
    init(
        showWakeUpTimePopup: Binding<Bool>,
        selectedWakeUpTime: Binding<Date>,
        previewPages: [[Habit]]? = nil
    ) {
        _showWakeUpTimePopup = showWakeUpTimePopup
        _selectedWakeUpTime = selectedWakeUpTime
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
    @Binding var showWakeUpTimePopup: Bool
    @Binding var selectedWakeUpTime: Date

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 24) {
                    VStack {
                        StreakView()
                        MapSectionView(cycle: Cycle(
                            cycleType: .starter,
                            cycleDuration: .starter
                        ))
                        AppLimitCardView()
                        HabitsSectionView(
                            pages: viewModel.pages,
                            prayerManager: prayerManager,
                            athkarManager: athkarManager,
                            showWakeUpTimePopup: $showWakeUpTimePopup,
                            selectedWakeUpTime: $selectedWakeUpTime
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 50)
            }

            if toastCenter.isPresented {
                ToastView(
                    message: toastCenter.message,
                    icon: "checkmark.circle.fill",
                    position: .bottom,
                    isPresented: $toastCenter.isPresented
                )
                .allowsHitTesting(false)
            }
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
    HomeView(
        showWakeUpTimePopup: .constant(false),
        selectedWakeUpTime: .constant(Date()),
        previewPages: [page1, page2, page3]
    )
}


