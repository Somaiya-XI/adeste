
import SwiftUI

struct HomeView: View {
    @State private var userManager = UserManager.shared
    @StateObject private var toastCenter = AppToastCenter.shared
    @State private var navigateToSettings = false
    
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
                        HStack(alignment: .center) {
                            StreakView()
                            
                            Spacer()
                            
                            SettingsButton {
                                navigateToSettings = true
                            }
                        }
                        .padding(.bottom, 16)
                        
                        HabitProgressBar()
                        AppLimitCardView()
                        
                        Spacer().frame(height: 50)
                        
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
        .navigationDestination(isPresented: $navigateToSettings) {
            SettingsView()
        }
        .onAppear {
            let habits = userManager.currentUser?.habits ?? []
            // Always reload — covers both first load and cycle change
            viewModel.loadHabits(habits)
            hasLoadedHabits = true
            AppStreakManager.shared.refreshForToday(habits: habits)
            AppProgressManager.shared.updateProgress(habits: habits)
        }

    }
}
#Preview("HomeView – Mock Data") {
    let page1: [Habit] = [
        Habit(title: "Water", type: .water),
//        Habit(title: "Steps", type: .steps),
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


