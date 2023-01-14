import SwiftUI

struct ContentView: View {

    @EnvironmentObject var provider: SensorDataProvider
    @State var isLoading = false

    var body: some View {
        VStack {
            Text("Temperature:")
            Text("\(provider.latestData?.temperature ?? 0)")
            Text("Humidity:")
            Text("\(provider.latestData?.humidity ?? 0)")
            Text("Last updated at:")
            Text("\(provider.latestData?.time ?? .distantPast)")
        }
        .padding()
        .task {
            await fetchSensorData()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SensorDataProvider())
    }
}
