import SwiftUI

struct TrainScreen: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Spacer()
                        Text("Train")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    NavigationLink(destination: DrillsListView()) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Drills")
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                Text("Practice focused drills")
                                    .font(.subheadline)
                                    .foregroundStyle(.black.secondary)
                            }
                            Spacer()
                            Image(systemName: "list.bullet")
                                .font(.title2)
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    NavigationLink(destination: ToolsListView()) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Tools")
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                Text("Recognition, trainers, trackers")
                                    .font(.subheadline)
                                    .foregroundStyle(.black.secondary)
                            }
                            Spacer()
                            Image(systemName: "wrench.and.screwdriver")
                                .font(.title2)
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
