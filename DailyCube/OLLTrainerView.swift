import SwiftUI

struct OLLTrainerView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("OLL Trainer")
                .font(.largeTitle)
                .bold()
            Text("Tool for training OLL recognition and execution.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .navigationTitle("OLL Trainer")
    }
}
