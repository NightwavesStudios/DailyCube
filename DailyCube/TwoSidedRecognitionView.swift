import SwiftUI

struct TwoSidedRecognitionView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("2-Sided Recognition")
                .font(.largeTitle)
                .bold()
            Text("Tool for practicing 2-sided recognition (to be implemented).")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
        .navigationTitle("2-Sided Recognition")
    }
}
