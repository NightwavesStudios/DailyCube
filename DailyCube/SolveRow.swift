import SwiftUI

struct SolveRow: View {
    let dayKey: String
    let solve: Solve
    @StateObject private var store = Store.shared

    var body: some View {
        HStack {
            Text(solve.adjustedDuration?.asClock() ?? "DNF")
                .font(.title3).monospacedDigit()
            Spacer()
            Picker("Penalty", selection: penaltyBinding) {
                Text(" ").tag(Solve.Penalty.none)
                Text("+2").tag(Solve.Penalty.plus2)
                Text("DNF").tag(Solve.Penalty.dnf)
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 180)
        }
    }

    private var penaltyBinding: Binding<Solve.Penalty> {
        Binding(
            get: { solve.penalty },
            set: { store.updateSolve(dayKey: dayKey, solveID: solve.id, penalty: $0) }
        )
    }
}
