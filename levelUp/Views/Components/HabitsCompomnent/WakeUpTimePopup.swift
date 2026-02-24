//
//  WakeUpTimePopup.swift
//  levelUp
//

import SwiftUI

struct WakeUpTimePopup: View {
    @Binding var isPresented: Bool
    @Binding var selectedWakeUpTime: Date

    var body: some View {
        VStack(spacing: 16) {
            Text("Wake up time")
                .font(.s24Medium)
                .foregroundStyle(.brand)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                DatePicker(
                    "Wake up",
                    selection: $selectedWakeUpTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
            }
            .frame(height: 180)
            .clipped()
            .padding()
            .background(Color.baseShade01)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            HStack(spacing: 16) {
                Button("Cancel") {
                    isPresented = false
                }
                .font(.s16Medium)
                .foregroundStyle(.brand)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.brand, lineWidth: 1)
                )

                Button("Save") {
                    AppHabitWakeUpManager.shared.updateTargetTime(to: selectedWakeUpTime)
                    AppToastCenter.shared.show(message: "Time Updated")
                    isPresented = false
                }
                .font(.s16Medium)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.brand)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(24)
        .frame(maxWidth: 320)
        .background(Color.baseShade01)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isPresented = true
        @State private var selectedTime = Date()
        var body: some View {
            WakeUpTimePopup(isPresented: $isPresented, selectedWakeUpTime: $selectedTime)
        }
    }
    return PreviewWrapper()
}
