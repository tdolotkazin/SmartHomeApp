import Combine

final class SensorDataProvider: ObservableObject {

    @MainActor @Published var latestData: SensorData?
    @MainActor @Published var allData: [SensorData] = []
    let client: SensorDataClient

    init(client: SensorDataClient = SensorDataClient()) {
        self.client = client
    }

    func fetchLatestData() async throws {
        let latestData = try await client.latestData

        await MainActor.run(body: {
            self.latestData = latestData
        })
    }

    func fetchAllData() async throws {
        let allData = try await client.allSensorData

        await MainActor.run(body: {
            self.allData = allData
        })
    }
}
