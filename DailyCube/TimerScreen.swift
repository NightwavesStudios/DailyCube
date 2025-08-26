import SwiftUI
import UserNotifications

struct TimerScreen: View {
    @StateObject private var timer = SolveTimer()
    @StateObject private var store = Store.shared
    @State private var scramble: String = Scrambler3x3.generate()
    // state for WCA-style start
    @State private var isPressed = false
    @State private var readyToStart = false

    var body: some View {
        VStack(spacing: 16) {
            // Header
            VStack(spacing: 8) {
                Text("\(Date(), formatter: DateFormatter.short)")
                    .font(.callout).foregroundStyle(.secondary)
                if let ao5 = store.today.ao5 {
                    Text("Today AO5: \(ao5.asClock())").font(.headline)
                } else {
                    Text("Do 5 solves for AO5").font(.headline)
                }
            }
            // Scramble
            Text(scramble)
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            // Big timer (tap zone)
            Text(timer.elapsed.asClock())
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .frame(maxWidth: .infinity, minHeight: 120)
                .padding(.vertical, 24)
                .contentShape(Rectangle())
                .foregroundColor(colorForTimerText())
                .gesture(longPressGesture)
                .simultaneousGesture(tapReleaseGesture)
            // Controls
            HStack(spacing: 12) {
                Button(action: { scramble = Scrambler3x3.generate() }) {
                    Label("New Scramble", systemImage: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(.bordered)
                Spacer()
                Button(action: toggleTimer) {
                    Label(timer.state == .running ? "Stop" : "Start",
                          systemImage: timer.state == .running ? "pause.circle" : "play.circle")
                }
                .buttonStyle(.borderedProminent)
                .disabled(store.today.solves.count >= 5 && timer.state != .running)
            }
            // Today list
            List {
                Section(header: Text("Today's Solves (\(store.today.solves.count)/5)")) {
                    ForEach(store.today.solves) { s in
                        HStack {
                            SolveRow(dayKey: store.todayKey, solve: s)
                            Spacer()
                            Button(role: .destructive) {
                                store.deleteSolve(dayKey: store.todayKey, solveID: s.id)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .buttonStyle(.plain)
                        }
                        // IMPORTANT: no onTapGesture that deletes; deletion only via the trash button.
                    }
                }
            }
        }
        .padding()
        .navigationTitle("CubeTime")
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
                // If timer is running, a tap should stop and save (fast stop).
                if timer.state == .running {
                    let t = timer.stop()
                    let solve = Solve(date: Date(),
                                      duration: t,
                                      scramble: scramble,
                                      penalty: .none)
                    store.addSolve(solve)
                    scramble = Scrambler3x3.generate()
                    // reset WCA style
                    isPressed = false
                    readyToStart = false
                    return
                }
                // If readyToStart (after long press) start
                if readyToStart {
                    timer.start()
                }
                isPressed = false
                readyToStart = false
            }
    }

    private func colorForTimerText() -> Color {
        if timer.state == .running { return .primary }
        if isPressed && !readyToStart { return .red }
        if readyToStart { return .green }
        return .primary
    }

    private func toggleTimer() {
        if timer.state == .running {
            let t = timer.stop()
            let solve = Solve(date: Date(),
                              duration: t,
                              scramble: scramble,
                              penalty: .none)
            store.addSolve(solve)
            scramble = Scrambler3x3.generate()
        } else {
            timer.start()
        }
    }
}

#Preview {
    ContentView()
}
