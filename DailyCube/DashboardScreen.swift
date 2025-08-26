import SwiftUI
import Charts

struct DashboardScreen: View {
    @StateObject private var store = Store.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Dashboard")
                            .font(.title)
                            .bold()
                            .frame(maxWidth: .infinity)
                        if let todayAO5 = store.today.ao5 {
                            Text("Today AO5: \(todayAO5.asClock())")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.bottom, 8)

                    // Daily AO5 Graph
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Last 30 Days (Ao5)")
                            .font(.headline)
                        if store.last30Ao5.isEmpty {
                            Text("No Ao5 yet. Complete five solves for today to see data.")
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
                    }

                    // Monthly AO5 Graph
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monthly Ao5 Averages")
                            .font(.headline)

                        if monthlyAo5.isEmpty {
                            Text("No monthly data yet. Complete some averages!")
                                .foregroundStyle(.secondary)
                        } else {
                            Chart(monthlyAo5, id: \.monthKey) { entry in
                                LineMark(
                                    x: .value("Month", entry.monthKey),
                                    y: .value("AO5", entry.value)
                                )
                                PointMark(
                                    x: .value("Month", entry.monthKey),
                                    y: .value("AO5", entry.value)
                                )
                            }
                            .frame(height: 220)
                        }
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Monthly Aggregation
    private var monthlyAo5: [MonthEntry] {
        let records = store.last30Ao5
        let grouped = Dictionary(grouping: records) { rec -> String in
            let comps = Calendar.current.dateComponents([.year, .month], from: rec.date)
            return String(format: "%04d-%02d", comps.year ?? 0, comps.month ?? 0)
        }
        return grouped.map { (month, recs) in
            let values = recs.compactMap { $0.ao5 }
            let avg = values.reduce(0, +) / Double(values.count)
            return MonthEntry(monthKey: month, value: avg)
        }
        .sorted { $0.monthKey < $1.monthKey }
    }

    struct MonthEntry: Identifiable {
        let id = UUID()
        let monthKey: String
        let value: Double
    }
}

#Preview {
    ContentView()
}
