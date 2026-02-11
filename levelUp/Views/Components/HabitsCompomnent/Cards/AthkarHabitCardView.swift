//
//  AthkarHabitCardView.swift
//  levelUp
//
//  Created by Jory on 23/08/1447 AH.
//

import SwiftUI

struct AthkarHabitCardView: View {
    var habit: Habit
    
  
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            VStack(alignment: .leading) {
                HStack {
                    Text(habit.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                Text("mmmm")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            HStack {
                Spacer()
                Image(systemName: athkarIcon)
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(habit.type.color)
        .frame(width: 168, height: 146)
        .cornerRadius(16)
    }
    // اختيار الأيقونة حسب الأذكار
    private var athkarIcon: String {
        if habit.title.contains("صباح") {
            return "cloud.sun.fill"   // أذكار الصباح
        } else {
            return "cloud.moon.fill"  // أذكار المساء
        }
    }
}

#Preview("Athkar Morning") {
    AthkarHabitCardView(habit: PreviewData.wakeUpHabit)
        .padding()
}


