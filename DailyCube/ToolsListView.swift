import SwiftUI

struct ToolsListView: View {
    let tools: [String] = [
        "2-sided recognition",
        "OLL Trainer",
        "PLL Trainer",
        "Splits Tracker",
        "Metronome"
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(tools, id: \.self) { t in
                    NavigationLink(destination: toolView(for: t)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(t)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("Practice tool")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Tools")
    }

    @ViewBuilder
    private func toolView(for tool: String) -> some View {
        switch tool {
        case "2-sided recognition": TwoSidedRecognitionView()
        case "OLL Trainer": OLLTrainerView()
        case "PLL Trainer": PLLTrainerView()
        case "Splits Tracker": SplitsTrackerView()
        case "Metronome": MetronomeView()
        default: fatalError("Unsupported tool: \(tool)")
        }
    }
}
