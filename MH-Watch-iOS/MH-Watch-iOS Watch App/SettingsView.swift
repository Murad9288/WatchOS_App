//
//  SettingsView.swift
//  MH-Watch-iOS
//
//  Created by Shadhin Music on 1/9/25.
//


import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var vm: TimerViewModel

    var body: some View {
        Form {
            Section("Focus Length") {
                Stepper("\(Int(vm.focusLength/60)) min",
                        value: Binding(
                            get: { Int(vm.focusLength/60) },
                            set: { vm.updateFocusLength(TimeInterval($0 * 60)) }
                        ),
                        in: 1...90)
            }
            Section("Break Length") {
                Stepper("\(Int(vm.breakLength/60)) min",
                        value: Binding(
                            get: { Int(vm.breakLength/60) },
                            set: { vm.updateBreakLength(TimeInterval($0 * 60)) }
                        ),
                        in: 1...30)
            }
            Section {
                Picker("Phase", selection: Binding(
                    get: { vm.phase == .focus ? 0 : 1 },
                    set: { vm.reset(to: $0 == 0 ? .focus : .breakTime) }
                )) {
                    Text("Focus").tag(0)
                    Text("Break").tag(1)
                }
            }
        }
        .navigationTitle("Settings")
    }
}
