//
//  HabitsSectionView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI


struct HabitsSectionView: View {
    let pages:[[Habit]]
    let prayerManager: PrayerManager
    let athkarManager: AthkarManager
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("Daily habit")
                .font(.s32Medium)
//                .font(.title2.bold())
                .foregroundColor(.brand)
            if pages.count > 1 {
                TabView {
                    ForEach(pages.indices, id: \.self) { index in
                        HabitsStaticLayoutView(
                            habits: pages[index],
                            prayerManager: prayerManager,
                            athkarManager: athkarManager
                        )
                        
                        .padding(.horizontal)
                    }
                }
                
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .frame(height: 320)
            }else if let firstPage = pages.first {
                HabitsStaticLayoutView(
                    habits: firstPage,
                    prayerManager: prayerManager,
                    athkarManager: athkarManager
                )
            }
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
                Habit(title: "Prayer", type: .prayer)
            ]
        ],
        prayerManager: prayerManager,
        athkarManager: athkarManager
    )
    .padding()
}
