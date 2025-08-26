import Foundation

struct Solve: Identifiable, Codable, Hashable {
    enum Penalty: String, Codable, CaseIterable { case none, plus2, dnf }

    var id: UUID = UUID()
    var date: Date = Date()
    var duration: TimeInterval // seconds
    var scramble: String
    var penalty: Penalty = .none

    var adjustedDuration: TimeInterval? {
        switch penalty {
        case .none: return duration
        case .plus2: return duration + 2
        case .dnf: return nil
        }
    }
}
