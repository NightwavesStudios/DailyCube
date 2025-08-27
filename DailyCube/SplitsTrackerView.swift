import SwiftUI

struct SplitsTrackerView: View {
    @StateObject private var timer = SolveTimer()
    @State private var splitDurations: [[TimeInterval]] = [[], [], [], []] // history for each phase
    @State private var currentSplits: [TimeInterval] = []
    @State private var labels = ["Cross", "F2L", "OLL", "PLL"]

    @State private var isPressed = false
    @State private var readyToStart = false
    @State private var isRunning = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Splits Tracker")
                .font(.largeTitle).bold()
            Text("Tap to record split times.")
                .foregroundStyle(.secondary)

            // Timer text
            Text(timer.elapsed.asClock())
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .padding()
                .frame(maxWidth: .infinity, minHeight: 120)
                .contentShape(Rectangle())
                .foregroundColor(colorForTimerText())
                .gesture(longPressGesture)
                .simultaneousGesture(tapReleaseGesture)

            // Splits list
            List {
                ForEach(Array(currentSplits.enumerated()), id: \.offset) { idx, t in
                    HStack {
                        Text(labels[idx])
                        Spacer()
                        Text("\(t.asClock())  |  ao\(splitDurations[idx].count): \(average(of: splitDurations[idx]).asClock())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // Show total if solve finished
            if currentSplits.count == labels.count {
                let total = currentSplits.reduce(0, +)
                Text("Total: \(total.asClock())")
                    .font(.headline)
            }

            Button("Reset") { reset() }
                .buttonStyle(.bordered)
        }
        .padding()
        .navigationTitle("Splits Tracker")
    }

    // MARK: - Gestures
    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.5)
            .onChanged { _ in
                isPressed = true
                readyToStart = false
            }
            .onEnded { _ in
                readyToStart = true
            }
    }

    private var tapReleaseGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { _ in
                if isRunning {
                    addSplit()
                } else if readyToStart {
                    startSolve()
                }
                isPressed = false
                readyToStart = false
            }
    }

    // MARK: - Logic
    private func startSolve() {
        currentSplits.removeAll()
        timer.start()
        isRunning = true
    }

    private func addSplit() {
        let splitTime: TimeInterval
        if let last = currentSplits.last {
            splitTime = timer.elapsed - currentSplits.reduce(0,+) // delta since last split
        } else {
            splitTime = timer.elapsed // first phase = elapsed
        }

        let idx = currentSplits.count
        if idx < labels.count {
            currentSplits.append(splitTime)
            splitDurations[idx].append(splitTime)
        }

        if currentSplits.count == labels.count {
            timer.stop()
            isRunning = false
        }
    }

    private func reset() {
        timer.reset()
        currentSplits.removeAll()
        isRunning = false
        isPressed = false
        readyToStart = false
    }

    private func colorForTimerText() -> Color {
        if isRunning { return .primary }
        if isPressed && !readyToStart { return .red }
        if readyToStart { return .green }
        return .primary
    }

    // Helpers
    private func average(of arr: [TimeInterval]) -> TimeInterval {
        guard !arr.isEmpty else { return 0 }
        return arr.reduce(0,+) / Double(arr.count)
    }
}
