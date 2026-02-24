//
//  IntentionsView.swift
//  levelUp
//
//  Created by Somaiya on 20/08/1447 AH.
//

import SwiftUI
import Combine
import FamilyControls
import Charts
import SwiftData

// selectedIntentionIcon -> currentIntention
// currentIntentionsCount -> minimumIntentions

struct IntentionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [
        SortDescriptor(\Intention.title),
        SortDescriptor(\Intention.icon)
    ]) var intentions: [Intention]
    
    @State var vm: IntentionsViewModel = .init()
    @State private var stopwatchTime: TimeInterval = 0
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let w = size.width
            let h = size.height
            
            // base zstack for popup
            ZStack(alignment: .center) {
                intentionAlert(vm: vm)

                VStack(alignment:.leading, spacing: 0) {
                    
                    // Header
                    HStack {
                        Text(consts.intentionpageStr)
                            .font(.s32Bold)
                            .foregroundStyle(.brand)
                        
                        Spacer()
                        
                        // Toolbar button to edit intentions
                        if vm.viewMode == .main {
                            Button {
                                withAnimation {
                                    vm.isEditing.toggle()
                                }
                            } label: {
                                Image(systemName: vm.isEditing ? consts.checkmarkIcon : consts.editIcon)
                                    .font(.s24Medium)
                                    .foregroundStyle(.brand)
                                    .frame(width: 40, height: 40)
                                    .background(.baseShade02)
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                        

                        // Toolbar button to stop the timer
                        if vm.viewMode == .timer {
                            Button {
                                withAnimation {
                                    stopwatchTime = 0
                                    vm.showStopwatchAlert.toggle()}

                            } label: {
                                Image(systemName: consts.stopTimerIconStr)
                                    .font(.s24Medium)
                                    .foregroundStyle(.brand)
                                    .frame(width: 40, height: 40)
                                    .background(.baseShade02)
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.plain)
                        }
                        
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    
                    
                    // Card: Intention / Stopwatch
                    VStack(alignment: .leading, spacing: 16) {
                        
                        if vm.viewMode == .timer {
                            /// Stopwatch Mode: User picked an intention, so we show the running timer
                            
                            VStack(spacing: 16) {
                                Text(consts.currentIntentionStr)
                                    .font(.s24Medium)
                                    .foregroundStyle(.brand)
                                Image(systemName: vm.currentIntention?.icon ?? "target")
                                    .font(.s24Medium)
                                    .foregroundStyle(.brand)
                                    .frame(width: 48, height: 48)
                                    .background(.baseShade03)
                                    .clipShape(Circle())
                                
                                Text(formattedStopwatchTime)
                                    .font(.s28Medium)
                                    .monospacedDigit()
                                    .foregroundStyle(.brand)
                                
                                Button(consts.stopStr) {
                                    vm.showStopwatchAlert.toggle()
                                    stopwatchTime = 0
                                }
                                .font(.s12Medium)
                                .foregroundStyle(.brand)
                                
                            }
                            .frame(maxWidth: .infinity)
                            .onAppear {
                                stopwatchTime = 0
                            }
                            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                                stopwatchTime += 1
                            }
                        }
                        
                        if vm.viewMode == .main {
                            /// Selection Mode: User has not picked yet, so we show the grid of intentions
                            Text(consts.startIntentionStr)
                                .font(.s24Medium)
                                .foregroundStyle(.brand)
                            
                            /// Max 6 intentions
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(intentions) { intention in
                                    
                                    IntentionButton(intention: intention, viewModel: vm)

                                }
                                
                                if intentions.count < vm.allowedIntentions {
                                    addMoreButton
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: h * 0.3)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.baseShade01)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    
                    // Summary
                    Text(consts.weeklySummaryStr)
                        .font(.s28Medium)
                        .foregroundStyle(.brand)
                        .padding(.top, 28)
                        .padding(.bottom, 16)
                        
                        // Donut Chart with apple charts & empty view
                        IntentionSummaryChart(viewModel: vm)
                    
                    
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: w, maxHeight: h)
                .background(.white)
                
                // Edit Intention Popup
                if vm.currentlyEditing != nil {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            vm.currentlyEditing = nil
                        }
                    
                    EditIntentionPopup(viewModel: vm)
                }
            }.onAppear {
                vm.configure(with: modelContext)
                
            }
        }
    }
    
    
    private var formattedStopwatchTime: String {
        let total = Int(stopwatchTime)
        
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    // Add more
    private var addMoreButton: some View {
        Button {
            let listOfIcons = ["target"]
            
            let newIntention = Intention(title: "", icon: listOfIcons.randomElement()!)
            vm.currentlyEditing = newIntention
            vm.isCreating = true
        } label: {
            VStack(spacing: 4) {
                Image(systemName: consts.plusIcon)
                    .font(.s24Medium)
                    .foregroundStyle(.brand)
                    .frame(width: 48, height: 48)
                    .background(.baseShade03)
                    .clipShape(Circle())
                
                Text(consts.addMoreStr)
                    .font(.s16Medium)
                    .foregroundStyle(.brand)
            }        }
        .buttonStyle(.plain)
    }
}

#Preview {
    IntentionsView()
        .modelContainer(previewContainer)
}


