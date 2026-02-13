//
//  HabitsPagedLayoutView.swift
//  HomePageUI
//
//  Created by Jory on 21/08/1447 AH.
//

import SwiftUI

struct HabitsPagedLayoutView: View {
    let pages: [[Habit]]
    let prayerManager: PrayerManager
    let athkarManager: AthkarManager
    var body: some View {
        TabView {
            ForEach(pages.indices,id: \.self) { index in HabitsStaticLayoutView(
                habits: pages[index],
                prayerManager: prayerManager,
                athkarManager: athkarManager
                
            )

                    .padding(.horizontal)
                
            }
        }
//            // Page 1
//            HabitsStaticLayoutView(state: .three)
//                .padding(.horizontal)
//
//            // Page ٢
//            HabitsStaticLayoutView(state: .two)
//                .padding(.horizontal)
        
    
        .tabViewStyle(.page(indexDisplayMode: .automatic))
       
        

    }
}


//#Preview {
//    HabitsPagedLayoutView()
//}
