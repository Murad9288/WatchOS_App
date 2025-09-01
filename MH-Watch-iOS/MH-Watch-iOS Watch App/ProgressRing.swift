//
//  ProgressRing.swift
//  MH-Watch-iOS
//
//  Created by Shadhin Music on 1/9/25.
//


import SwiftUI

struct ProgressRing: View {
    let progress: Double   // 0...1
    let label: String
    let timeText: String
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.15)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.2), value: progress)
            VStack(spacing: 6) {
                Text(label)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text(timeText)
                    .font(.title2.monospacedDigit())
                    .bold()
            }
        }
        .padding(8)
    }
}
