import Foundation

extension TimeInterval {
    func asClock() -> String {
        let total = Int(self * 100) // hundredths
        let minutes = total / 6000
        let seconds = (total % 6000) / 100
        let hundredths = total % 100

        if minutes > 0 {
            return String(format: "%d:%02d.%02d", minutes, seconds, hundredths)
        } else {
            return String(format: "%d.%02d", seconds, hundredths)
        }
    }
}
