import Foundation

@MainActor
final class Store: ObservableObject {
    static let shared = Store()

    @Published private(set) var dayMap: [String: DayRecord] = [:]

    private let url: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("cubetime.json")
    }()

    var todayKey: String { DayRecord.dayKey(for: Date()) }
    var today: DayRecord { dayMap[todayKey] ?? DayRecord(date: Date(), solves: []) }

    init() { load() }

    func addSolve(_ solve: Solve) {
        var rec = today
        guard rec.solves.count < 5 else { return } // cap at 5 per day
        rec.solves.insert(solve, at: 0)
        dayMap[todayKey] = rec
        save()
    }
    
    func updateSolve(dayKey: String, solveID: UUID, penalty: Solve.Penalty) {
        guard var rec = dayMap[dayKey],
              let idx = rec.solves.firstIndex(where: { $0.id == solveID }) else { return }
        rec.solves[idx].penalty = penalty
        dayMap[dayKey] = rec
        save()
    }

    func deleteSolve(dayKey: String, solveID: UUID) {
        guard var rec = dayMap[dayKey] else { return }
        rec.solves.removeAll { $0.id == solveID }
        dayMap[dayKey] = rec
        save()
    }

    var last30Ao5: [DayRecord] {
        let now = Date()
        var out: [DayRecord] = []
        for i in 0..<30 {
            if let d = Calendar.current.date(byAdding: .day, value: -i, to: now) {
                let key = DayRecord.dayKey(for: d)
                if let r = dayMap[key], r.ao5 != nil {
                    out.append(r)
                }
            }
        }
        return out.sorted { $0.date < $1.date }
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(dayMap)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Save error: \(error)")
        }
    }

    private func load() {
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            let data = try Data(contentsOf: url)
            let value = try JSONDecoder().decode([String: DayRecord].self, from: data)
            dayMap = value
        } catch {
            print("Load error: \(error)")
        }
    }
    
    
}
