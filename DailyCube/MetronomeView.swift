import SwiftUI

struct MetronomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Metronome")
                .font(.largeTitle)
                .bold()
            Text("Tool for practicing TPS with metronome beats.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .navigationTitle("Metronome")
    }
}
