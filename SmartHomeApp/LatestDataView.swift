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
                Text("Last updated at: \(DateFormatter.allDataTimeFormatter.string(from: (provider.latestData?.baseLastUpdatedTime ?? .distantPast)))")
                HStack {
                    Text("Boiler is running:")
                    if (provider.latestData?.isBoilerRunning) == true {
                        Circle()
                            .fill(.green)
                            .frame(width: 16, height: 16)
                    } else {
                        Circle()
                            .fill(.red)
                            .frame(width: 16, height: 16)
                    }
                }
                Text("Water temperature:")
                Text("\(provider.latestData?.waterTemperature ?? 0)")
                Text("Boiler last updated at: \(DateFormatter.allDataTimeFormatter.string(from: (provider.latestData?.boilerLastUpdatedTime ?? .distantPast)))")
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
