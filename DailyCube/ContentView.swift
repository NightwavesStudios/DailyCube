import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardScreen()
                .tabItem { Label("Dashboard", systemImage: "chart.line.uptrend.xyaxis") }
            TimerScreen()
                .tabItem { Label("Time", systemImage: "timer") }
            //TrainScreen()
                .tabItem { Label("Train", systemImage: "figure.run") }
            //SettingsScreen()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

#Preview {
    ContentView()
}
