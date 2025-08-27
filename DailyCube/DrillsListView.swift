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
        .init(title: "Slow Solves", description: "Slow solving is when you deliberately turn at a very slow speed. It is very simple to preform, just pick up a cube and slowly turn it thinking about every move. This helps with discovering better f2l case solutions, improving your cross, and starting to learn lookahead.", videoURL: nil, suggestedTool: nil),
        .init(title: "Blind Solves", description: "Train lookahead, and cross planning.", videoURL: nil, suggestedTool: nil),
        .init(title: "2-Gen", description: "Repetition of 2-generator algs to build speed.", videoURL: nil, suggestedTool: "Scramble Generator"),
        .init(title: "PLL Time Attack", description: "Timed PLL-only solves to improve speed.", videoURL: nil, suggestedTool: "PLL Trainer"),
        .init(title: "TPS Training", description: "TPS Training is training where you go at max speed to increase your TPS over time. When you do this drill, you will find yourself locking up, but this is not a bad thing. To preform, select an algorithm. Normally this will be a PLL for it's fingertricks and length. Then, simply push it to your max speed.", videoURL: URL(string: "https://www.youtube.com/watch?v=VCz6zq2iyRM"), suggestedTool: "Metronome"),
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

