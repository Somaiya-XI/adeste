//
//  ToastView.swift
//  levelUp
//

import SwiftUI
import Combine

final class AppToastCenter: ObservableObject {
    static let shared = AppToastCenter()

    @Published var isPresented: Bool = false
    @Published var message: String = "Progress Saved!"

    func show(message: String = "Progress Saved!") {
        self.message = message
        self.isPresented = true
    }
}

enum ToastPosition {
    case top
    case bottom
}

struct ToastView: View {
    var message: String
    var icon: String = "checkmark.circle.fill"
    var position: ToastPosition = .top
    @Binding var isPresented: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.s20Medium)
                .foregroundStyle(.brand)

            Text(message)
                .font(.s16Medium)
                .foregroundStyle(Color("brand-color"))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.baseShade01)
        )
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .frame(maxHeight: .infinity, alignment: position == .top ? .top : .bottom)
        .padding(.top, position == .top ? 56 : 0)
        .padding(.bottom, position == .bottom ? 140 : 0)
        .transition(.opacity.combined(with: .move(edge: position == .top ? .top : .bottom)))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeOut(duration: 0.25)) {
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var show = true
        var body: some View {
            ZStack {
                Color.gray.opacity(0.3).ignoresSafeArea()
                if show {
                    ToastView(message: "Progress Saved!", isPresented: $show)
                }
            }
        }
    }
    return PreviewWrapper()
}
