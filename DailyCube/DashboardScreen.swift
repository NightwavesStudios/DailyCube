import SwiftUI
import Charts

struct DashboardScreen: View {
    @StateObject private var store = Store.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Last 30 Days AO5")
                    .font(.headline)

                if store.last30Ao5.isEmpty {
                    Text("No AO5 yet. Do five solves today.")
                        .foregroundStyle(.secondary)
                } else {
                    Chart(store.last30Ao5, id: \.id) { rec in
                        if let v = rec.ao5 {
                            LineMark(
                                x: .value("Day", rec.date),
                                y: .value("AO5", v)
                            )
                            PointMark(
                                x: .value("Day", rec.date),
                                y: .value("AO5", v)
                            )
                        }
                    }
                    .frame(height: 220)
                }

                if let todayAO5 = store.today.ao5 {
                    VStack(alignment: .leading) {
                        Text("Today AO5")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(todayAO5.asClock())
                            .font(.title)
                            .monospacedDigit()
                    }
                }
            }
            .padding()
        }
    }
}
