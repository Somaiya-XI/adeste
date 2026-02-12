//
//  WakeUpHabitCardView.swift
//  levelUp
//
//  Created by Jory on 22/08/1447 AH.
//

import SwiftUI


struct WakeUpHabitCardView: View {
   
    @StateObject var viewModel: WakeUpViewModel
    init(habit: Habit) {
            _viewModel = StateObject(
                wrappedValue: WakeUpViewModel(
                    habit: habit,
                    wakeUpTime: Calendar.current.date(
                        bySettingHour: 7,
                        minute: 45,
                        second: 0,
                        of: Date()
                    )!
                )
            )
        }

        var body: some View {
                        VStack(alignment: .leading, spacing: 8) {
                            VStack(alignment: .leading) {
                                
                                
                                HStack{
                                    Text("Wake up")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    
                                    Button {
                                        viewModel.checkIn()
                                    } label: {
                                        Image(systemName: viewModel.didCheckIn ?  "checkmark.circle.fill" : "checkmark.circle")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                        
                                    }
                                    
                                }
                              
                                Text(viewModel.wakeUpTime.formatted(
                                    date: .omitted,
                                    time: .shortened)
                                     )
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                            }
                            
                            HStack {
                                           Spacer()
                                           Image(systemName: "sun.max")
                                               .font(.system(size: 40))
                                               .foregroundColor(.white.opacity(0.7))
                                       }
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.secColorMustard)
            .cornerRadius(16)
        }
    }



#Preview {

    let habit = Habit(
        id: UUID().uuidString,
        title: "Wake Up",
        type: .wakeUp,
        isEnabled: true
    )

    WakeUpHabitCardView(habit: habit)
        .padding()
        
}



