//
//  MH_Watch_iOSApp.swift
//  MH-Watch-iOS Watch App
//
//  Created by Shadhin Music on 1/9/25.
//

import SwiftUI

@main
struct MH_WatchApp: App {
    @StateObject private var timerVM = TimerViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(timerVM)
            }
        }
    }
}
