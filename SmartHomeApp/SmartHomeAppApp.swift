import SwiftUI

@main
struct SmartHomeAppApp: App {
    @StateObject var sensorDataProvider = SensorDataProvider()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sensorDataProvider)
        }
    }
}
