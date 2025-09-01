//
//  TimerViewModel.swift
//  MH-Watch-iOS
//
//  Created by Shadhin Music on 1/9/25.
//


import Foundation
import Combine
import WatchKit

final class TimerViewModel: ObservableObject {
    enum Phase { case focus, breakTime }
    
    @Published var isRunning: Bool = false
    @Published var phase: Phase = .focus
    @Published var focusLength: TimeInterval = 25 * 60   // 25 min
    @Published var breakLength: TimeInterval = 5 * 60    // 5 min
    @Published private(set) var remaining: TimeInterval = 25 * 60
    
    private var tick: AnyCancellable?
    private var lastStart: Date?
    
    init() {
        reset(to: .focus)
    }
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        lastStart = Date()
        scheduleTick()
        WKInterfaceDevice.current().play(.start)
    }
    
    func pause() {
        guard isRunning else { return }
        isRunning = false
        tick?.cancel()
        WKInterfaceDevice.current().play(.stop)
    }
    
    func toggle() {
        isRunning ? pause() : start()
    }
    
    func reset(to phase: Phase? = nil) {
        if let p = phase { self.phase = p }
        remaining = (self.phase == .focus) ? focusLength : breakLength
        isRunning = false
        tick?.cancel()
    }
    
    func switchPhase() {
        phase = (phase == .focus) ? .breakTime : .focus
        reset()
        start()
    }
    
    func updateFocusLength(_ seconds: TimeInterval) {
        focusLength = max(60, min(60*90, seconds))
        if phase == .focus, !isRunning { remaining = focusLength }
    }
    
    func updateBreakLength(_ seconds: TimeInterval) {
        breakLength = max(60, min(60*30, seconds))
        if phase == .breakTime, !isRunning { remaining = breakLength }
    }
    
    private func scheduleTick() {
        tick?.cancel()
        tick = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self else { return }
                guard self.isRunning else { return }
                self.remaining -= 1
                if self.remaining <= 0 {
                    self.remaining = 0
                    self.isRunning = false
                    self.tick?.cancel()
                    // Haptic alert + phase switch
                    WKInterfaceDevice.current().play(.notification)
                    // ছোট delay দিয়ে next phase
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.switchPhase()
                    }
                }
            }
    }
}
