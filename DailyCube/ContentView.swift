import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("DailyCube")
                .font(.title)
                .fontWeight(.bold)
                .padding(5)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
        }
        TabView {
            DashboardScreen()
                .tabItem { Label("Dashboard", systemImage: "chart.line.uptrend.xyaxis") }
            TimerScreen()
                .tabItem { Label("Time", systemImage: "timer") }
            //TrainScreen()
            TimerScreen() //placeholder
                .tabItem { Label("Train", systemImage: "figure.run") }
            //SettingsScreen()
            TimerScreen() //placeholder
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
}

#Preview {
    ContentView()
}
