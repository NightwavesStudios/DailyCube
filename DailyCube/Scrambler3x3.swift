import Foundation

struct Scrambler3x3 {
    static let faces = ["U","D","L","R","F","B"]
    static let modifiers = ["","'","2"]
    static let opposites: [String:String] = ["U":"D","D":"U","L":"R","R":"L","F":"B","B":"F"]

    static func generate(length: Int = 25) -> String {
        var seq: [String] = []
        var last: String? = nil
        var last2: String? = nil

        while seq.count < length {
            let f = faces.randomElement()!
            if f == last { continue }
            if let l = last, let o = opposites[l], f == o, let l2 = last2, l2 == f { continue }
            let m = modifiers.randomElement()!
            seq.append(f + m)
            last2 = last
            last = f
        }
        return seq.joined(separator: " ")
    }
}
