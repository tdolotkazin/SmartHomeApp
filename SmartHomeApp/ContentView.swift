import SwiftUI

struct ContentView: View {

    @EnvironmentObject var provider: SensorDataProvider
    @State var isLoading = false

    var body: some View {
        TabView {
            LatestDataView()
                .tabItem {
                    Label("Latest", systemImage: "thermometer.sun.fill")
                }
            AllDataView()
                .tabItem {
                    Label("All", systemImage: "chart.xyaxis.line")
                }
        }
    }

    func fetchSensorData() async {
        isLoading = true
        do {
            try await provider.fetchLatestData()
        } catch {
            print(error)
        }
        isLoading = false
    }

    func fetchAllData() async {
        isLoading = true
        do {
            try await provider.fetchLatestData()
        } catch {
            print(error)
        }
        isLoading = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SensorDataProvider())
    }
}
