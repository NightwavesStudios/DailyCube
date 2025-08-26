import Foundation

struct DayRecord: Identifiable, Codable, Hashable {
    var id: String { Self.dayKey(for: date) }
    var date: Date
    var solves: [Solve]

    // WCA-style Ao5
    var ao5: TimeInterval? {
        guard solves.count >= 5 else { return nil }
        let latestFive = Array(solves.prefix(5))

        let dnfCount = latestFive.filter { $0.penalty == .dnf }.count
        if dnfCount >= 2 { return nil }

        let values = latestFive.compactMap { $0.adjustedDuration }
        let expanded = values + (dnfCount == 1 ? [Double.greatestFiniteMagnitude] : [])
        guard expanded.count == 5 else { return nil }

        let sorted = expanded.sorted()
        let middle = sorted.dropFirst().dropLast()
        return middle.reduce(0, +) / 3.0
    }

    static func dayKey(for date: Date) -> String {
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", comps.year ?? 0, comps.month ?? 0, comps.day ?? 0)
    }
}
