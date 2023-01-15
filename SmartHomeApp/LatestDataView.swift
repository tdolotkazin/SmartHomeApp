import SwiftUI

struct LatestDataView: View {

    @EnvironmentObject var provider: SensorDataProvider
    @State var isLoading = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                Text("Temperature:")
                Text("\(provider.latestData?.temperature ?? 0)")
                Text("Humidity:")
                Text("\(provider.latestData?.humidity ?? 0)")
                Text("Last updated at:")
                Text("\(DateFormatter.allDataDateFormatter.string(from: (provider.latestData?.time ?? .distantPast)))")
            }

            Button {
                Task {
                    await fetchSensorData()
                }
            } label: {
                Text("Refresh")
            }
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

struct LatestDataView_Previews: PreviewProvider {
    static var previews: some View {
        LatestDataView()
            .environmentObject(SensorDataProvider())
    }
}
