import Foundation

final class SensorDataClient {
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return aDecoder
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()

    private let apiURL = URL(string: "http://95.163.234.191:8000/latestData")!

    private let urlSession = URLSession(configuration: .default)

    var latestData: SensorData {
        get async throws {
            let data = try await urlSession.data(for: URLRequest(url: apiURL)).0
            let decodedData: SensorData = try decoder.decode(SensorData.self, from: data)
            return decodedData
        }
    }
}
