import SwiftUI

struct PLLTrainerView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("PLL Trainer")
                .font(.largeTitle)
                .bold()
            Text("Tool for training PLL recognition and execution.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .navigationTitle("PLL Trainer")
    }
}
