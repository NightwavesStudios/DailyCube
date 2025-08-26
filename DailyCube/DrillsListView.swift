import SwiftUI
import AVKit

struct Drill: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let videoURL: URL?
    let suggestedTool: String?
}

struct DrillsListView: View {
    @State private var drills: [Drill] = [
        .init(title: "Slow Solves", description: "Slow, deliberate solves focusing on inspection, lookahead and turning efficiency.", videoURL: nil, suggestedTool: nil),
        .init(title: "Blind Solves", description: "Practice solving with blindfold techniques.", videoURL: nil, suggestedTool: nil),
        .init(title: "Blind F2L", description: "Focus on blind recognition and execution of F2L.", videoURL: nil, suggestedTool: nil),
        .init(title: "2-Gen", description: "Repetition of 2-generator algs to build speed.", videoURL: nil, suggestedTool: "PLL Trainer"),
        .init(title: "PLL Time Attack", description: "Timed PLL-only solves to improve speed.", videoURL: nil, suggestedTool: "PLL Trainer"),
        .init(title: "TPS Training", description: "Turns-per-second drills with metronome.", videoURL: nil, suggestedTool: "Metronome"),
        .init(title: "Metronome Solves", description: "Solves synced to a metronome beat.", videoURL: nil, suggestedTool: "Metronome")
    ]
    @State private var selectedDrill: Drill?

    var body: some View {
        List {
            ForEach(drills) { drill in
                Button {
                    selectedDrill = drill
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(drill.title)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text(drill.description)
                                .font(.subheadline)
                                .lineLimit(2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
//                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Drills")
        .sheet(item: $selectedDrill) { drill in
            DrillDetailSheet(drill: drill)
            .presentationBackground(Color.white)
        }
    }
}

struct DrillDetailSheet: View {
    let drill: Drill
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text(drill.title)
                        .font(.title)
                        .bold()
                    Text(drill.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)

                    if let url = drill.videoURL {
                        VideoPlayer(player: AVPlayer(url: url))
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    if let tool = drill.suggestedTool {
                        NavigationLink(destination: toolView(for: tool)) {
                            Text("Practice with \(tool)")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(drill.title)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .background(Color.white.ignoresSafeArea()) // <- forces white background behind everything
    }
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

