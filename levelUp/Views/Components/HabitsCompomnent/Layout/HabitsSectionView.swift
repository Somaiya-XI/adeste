
import SwiftUI


struct HabitsSectionView: View {
    let pages: [[Habit]]
    let prayerManager: PrayerManager
    let athkarManager: AthkarManager
    @Binding var showWakeUpTimePopup: Bool
    @Binding var selectedWakeUpTime: Date
    
    
    // Goal sheet state
    @State private var showGoalSheet = false
    @State private var showNoGoalsAlert = false
    
    @State private var wakeUpTime: Date = AppHabitWakeUpManager.shared.wakeUpTime
    @State private var stepGoal: Int = UserDefaults.standard.integer(forKey: "saved_step_goal") == 0
    ? 8000
    : UserDefaults.standard.integer(forKey: "saved_step_goal")
    
    
    
    // Derive which goal-able habits the user actually has
    private var allHabits: [Habit] { pages.flatMap { $0 } }
    private var hasWakeUp: Bool { allHabits.contains { $0.type == .wakeUp } }
    private var hasSteps: Bool  { allHabits.contains { $0.type == .steps  } }
    private var goalHabits: Set<String> {
        var set = Set<String>()
        if hasWakeUp { set.insert("Wake Up") }
        if hasSteps  { set.insert("Walk") }
        return set
    }
    
    private var currentCycleType: CycleType {
        // Match the stored cycleId against known cycle types via UserManager
        guard let cycleId = UserManager.shared.currentUser?.currentCycleId else { return .starter }
        // CycleType raw values: "Awareness", "Consistency", "Foundation", "Growth"
        // We store cycleId as UUID, so we need to pass cycleType separately — use UserDefaults as fallback
        if let raw = UserDefaults.standard.string(forKey: "currentCycleType"),
           let type = CycleType(rawValue: raw) {
            return type
        }
        return .starter
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Daily habit")
                    .font(.s24Semibold)
                    .foregroundColor(.brand)
                
                Spacer()
                
                Menu {
                    Button {
                        if goalHabits.isEmpty {
                            showNoGoalsAlert = true
                        } else {
                            wakeUpTime = AppHabitWakeUpManager.shared.wakeUpTime
                            let saved = UserDefaults.standard.integer(forKey: "saved_step_goal")
                            stepGoal = saved == 0 ? 8000 : saved
                            showGoalSheet = true
                        }
                    } label: {
                        Label("Edit Goals", systemImage: "pencil")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.brand)
                }
            }
            if pages.count > 1 {
                TabView {
                    ForEach(pages.indices, id: \.self) { index in
                        HabitsStaticLayoutView(
                            habits: pages[index],
                            prayerManager: prayerManager,
                            athkarManager: athkarManager,
                            showWakeUpTimePopup: $showWakeUpTimePopup,
                            selectedWakeUpTime: $selectedWakeUpTime
                        )
                        .padding(.horizontal)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .frame(height: 320)
            } else if let firstPage = pages.first {
                HabitsStaticLayoutView(
                    habits: firstPage,
                    prayerManager: prayerManager,
                    athkarManager: athkarManager,
                    showWakeUpTimePopup: $showWakeUpTimePopup,
                    selectedWakeUpTime: $selectedWakeUpTime
                )
            }
            
        }
        
        .alert("No goals to edit", isPresented: $showNoGoalsAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You don't have any habits with goals.")
        }
        .sheet(isPresented: $showGoalSheet) {
            HabitsGoalSheet(
                selectedHabits: goalHabits,
                selectedWakeUpTime: $wakeUpTime,
                stepGoal: $stepGoal,
                isOnboarding: false,
                cycleType: currentCycleType
            )
            .presentationDetents([.large])
        }
    }
}

#Preview("HabitsSection – Single Page") {
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
    
    HabitsSectionView(
        pages: [
            [
                Habit(title: "Water", type: .water),
                Habit(title: "Steps", type: .steps),
                Habit(title: "Wake Up", type: .wakeUp)
            ]
        ],
        prayerManager: prayerManager,
        athkarManager: athkarManager,
        showWakeUpTimePopup: .constant(false),
        selectedWakeUpTime: .constant(Date())
    )
    .padding()
}
