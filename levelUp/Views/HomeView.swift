//
//  HomeView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI


let mockHabits: [Habit] = {
    let h1 = Habit(
        id: UUID().uuidString,
        title: "Wake Up",
        type: .wakeUp,
        isEnabled: true
    )

    let h2 = Habit(
        id: UUID().uuidString,
        title: "Steps",
        type: .steps,
        isEnabled: true
    )

    let h3 = Habit(
        id: UUID().uuidString,
        title: "Water Intake",
        type: .water,
        isEnabled: true
    )

    let h4 = Habit(
        id: UUID().uuidString,
        title: "Athkar",
        type: .wakeUp, // أو سوي type جديد لو حابة
        isEnabled: true
    )

    return [h1, h2, h3, h4]
}()



struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Daily habit")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.pages.indices, id: \.self) { index in
                        HabitPageView(habits: viewModel.pages[index])
                            .frame(width: UIScreen.main.bounds.width - 32)
                    }
                }
            }

        }
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.loadHabits(mockHabits)
//            viewModel.updateSteps()
        }
    }
}


#Preview {
    HomeView()
}
