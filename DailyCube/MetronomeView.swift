import SwiftUI
import AVFoundation

struct MetronomeView: View {
    @State private var tps: Double = 2.0
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    private var player: AVAudioPlayer?

    var body: some View {
        VStack(spacing: 24) {
            Text("Metronome")
                .font(.largeTitle).bold()
            Text("Set beats per second (TPS)")
                .foregroundStyle(.secondary)

            Stepper(value: $tps, in: 1...15, step: 0.5) {
                Text("TPS: \(tps, specifier: "%.1f")")
            }

            Button(isRunning ? "Stop" : "Start") {
                toggle()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Metronome")
    }

    private func toggle() {
        if isRunning {
            timer?.invalidate()
            timer = nil
            isRunning = false
        } else {
            let interval = 1.0 / tps
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                playClick()
            }
            RunLoop.current.add(timer!, forMode: .common)
            isRunning = true
        }
    }

    private func playClick() {
        AudioServicesPlaySystemSound(1104) // system "tick" sound
    }
}
