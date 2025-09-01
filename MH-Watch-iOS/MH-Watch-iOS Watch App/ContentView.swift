//
//  ContentView.swift
//  MH-Watch-iOS Watch App
//
//  Created by Shadhin Music on 1/9/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: TimerViewModel
    @State private var crownValue: Double = 0 // minutes delta via Digital Crown

    private var total: TimeInterval {
        vm.phase == .focus ? vm.focusLength : vm.breakLength
    }
    private var progress: Double {
        guard total > 0 else { return 0 }
        return 1 - (vm.remaining / total)
    }
    private var label: String {
        vm.phase == .focus ? "FOCUS" : "BREAK"
    }
    private var timeText: String {
        let m = Int(vm.remaining) / 60
        let s = Int(vm.remaining) % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        VStack(spacing: 10) {
            ProgressRing(progress: progress, label: label, timeText: timeText)
                .frame(height: 120)
                .focusable(true)
                .digitalCrownRotation(
                    $crownValue,
                    from: -30, through: 30, by: 1,
                    sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true
                )
                .onChange(of: crownValue) { old, newVal in
                    let deltaMinutes = newVal - old
                    let deltaSeconds = deltaMinutes * 60
                    if vm.phase == .focus {
                        vm.updateFocusLength(vm.focusLength + deltaSeconds)
                    } else {
                        vm.updateBreakLength(vm.breakLength + deltaSeconds)
                    }
                }

            HStack(spacing: 12) {
                Button(vm.isRunning ? "Pause" : "Start") {
                    vm.toggle()
                }
                .font(.headline)
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    vm.reset()
                }
                .buttonStyle(.bordered)
            }

            NavigationLink("Settings") {
                SettingsView()
            }
            .font(.footnote)
            .padding(.top, 2)
        }
        .padding(.horizontal, 8)
    }
}
