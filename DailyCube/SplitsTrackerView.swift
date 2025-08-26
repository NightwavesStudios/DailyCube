import SwiftUI

struct SplitsTrackerView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Splits Tracker")
                .font(.largeTitle)
                .bold()
            Text("Tool for tracking split times within solves.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .navigationTitle("Splits Tracker")
    }
}
