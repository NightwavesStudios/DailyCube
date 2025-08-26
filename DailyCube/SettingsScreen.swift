import SwiftUI
import UserNotifications

struct SettingsScreen: View {
    @StateObject private var store = Store.shared
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = false
    @AppStorage("notificationHour") private var notificationHour: Int = 20
    @AppStorage("notificationMinute") private var notificationMinute: Int = 0

    @State private var showDeleteConfirm = false
    @State private var showPermissionAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Notify if Ao5 not completed", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { newValue in
                            if newValue {
                                requestAuthorizationAndSchedule()
                            } else {
                                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyAo5Check"])
                            }
                        }

                    if notificationsEnabled {
                        HStack {
                            Text("Time")
                            Spacer()
                            DatePicker("", selection: Binding(get: {
                                dateFromHourMinute()
                            }, set: { newDate in
                                let comps = Calendar.current.dateComponents([.hour, .minute], from: newDate)
                                notificationHour = comps.hour ?? 20
                                notificationMinute = comps.minute ?? 0
                                scheduleNotificationIfNeeded() // reschedule
                            }), displayedComponents: .hourAndMinute)
                            .labelsHidden()
                        }
                        Button("Send Test Notification") {
                            scheduleTestNotification()
                        }
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showDeleteConfirm = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Delete All Data")
                            Spacer()
                        }
                    }
                    .confirmationDialog("Are you sure you want to delete all data? This cannot be undone.", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                        Button("Delete All", role: .destructive) {
                            // call store delete all
                          //  store.deleteAllData()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                // ensure pending notification is scheduled if toggle is on
                if notificationsEnabled {
                    scheduleNotificationIfNeeded()
                }
            }
        }
    }

    // Helper: convert stored hour/minute to Date
    private func dateFromHourMinute() -> Date {
        var comps = DateComponents()
        comps.hour = notificationHour
        comps.minute = notificationMinute
        return Calendar.current.date(from: comps) ?? Date()
    }

    private func requestAuthorizationAndSchedule() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    scheduleNotificationIfNeeded()
                } else {
                    notificationsEnabled = false
                    showPermissionAlert = true
                }
            }
        }
    }

    private func scheduleNotificationIfNeeded() {
        guard notificationsEnabled else { return }
        // Check today AO5; if not completed, schedule notification at chosen time
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyAo5Check"])

        var dateComps = DateComponents()
        dateComps.hour = notificationHour
        dateComps.minute = notificationMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: true)
        let content = UNMutableNotificationContent()
        content.title = "Daily Ao5 Check"
        content.body = "You haven't completed your Ao5 today. Do 5 solves to log your AO5."
        content.sound = .default

        // We include a small logic in the delivered content only — real check will occur in app once tapped
        let request = UNNotificationRequest(identifier: "dailyAo5Check", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let e = error {
                print("Failed to schedule notification:", e.localizedDescription)
            }
        }
    }

    private func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test: Daily Ao5 Check"
        content.body = "This is a test notification."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "dailyAo5Test", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
