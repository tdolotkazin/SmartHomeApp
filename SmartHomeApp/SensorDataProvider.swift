import Combine

final class SensorDataProvider: ObservableObject {

    @Published var latestData: SensorData?
    let client: SensorDataClient

    init(client: SensorDataClient = SensorDataClient()) {
        self.client = client
    }

    func fetchLatestData() async throws {
        let latestData = try await client.latestData
        self.latestData = latestData
    }

}
