import Foundation
import SwiftUI

@MainActor
final class SolveTimer: ObservableObject {
    enum State { case idle, ready, running }
    @Published var state: State = .idle
    @Published private(set) var elapsed: TimeInterval = 0

    private var startAt: Date? = nil
    private var link: CADisplayLink? = nil

    func reset() {
        link?.invalidate(); link = nil
        elapsed = 0; startAt = nil; state = .idle
    }

    func start() {
        guard state != .running else { return }
        startAt = Date()
        state = .running
        let dl = CADisplayLink(target: self, selector: #selector(tick))
        dl.add(to: .main, forMode: .common)
        link = dl
    }

    func stop() -> TimeInterval {
        link?.invalidate(); link = nil
        let t = elapsed
        reset()
        return t
    }

    @objc private func tick() {
        guard let s = startAt else { return }
        elapsed = Date().timeIntervalSince(s)
    }
}
