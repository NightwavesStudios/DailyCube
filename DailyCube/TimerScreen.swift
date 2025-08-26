import SwiftUI

struct TimerScreen: View {
    @StateObject private var timer = SolveTimer()
    @StateObject private var store = Store.shared
    @State private var scramble: String = Scrambler3x3.generate()

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

            // Big timer
            Text(timer.elapsed.asClock())
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .monospacedDigit()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .contentShape(Rectangle())
                .onTapGesture { toggleTimer() }
                .onLongPressGesture { timer.reset() }
                .background(timer.state == .running ? Color.green.opacity(0.15) : Color.clear)
                .animation(.easeInOut, value: timer.state)

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
                        SolveRow(dayKey: store.todayKey, solve: s)
                    }
                    .onDelete { idx in
                        for i in idx {
                            store.deleteSolve(dayKey: store.todayKey,
                                              solveID: store.today.solves[i].id)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("CubeTime")
    }

    private func toggleTimer() {
        if timer.state == .running {
            let t = timer.stop()
            let solve = Solve(date: Date(),
                              duration: t,
                              scramble: scramble,
                              penalty: .none)
            Store.shared.addSolve(solve)
            scramble = Scrambler3x3.generate()
        } else {
            timer.start()
        }
    }
}
