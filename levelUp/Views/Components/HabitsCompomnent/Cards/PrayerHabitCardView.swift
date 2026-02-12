////
////  PrayerHabitCardView.swift
////  levelUp
////
////  Created by Jory on 23/08/1447 AH.
////

import SwiftUI

struct PrayerHabitCardView: View {
    var habit: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Prayer")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                Text("Prayer")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            HStack {
                Spacer()
                Image(systemName: "")
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(Color.secColorBerry)
        .frame(width: 168, height: 146)
        .cornerRadius(16)
    }}
