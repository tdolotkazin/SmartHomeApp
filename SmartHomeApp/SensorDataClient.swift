import Foundation

final class SensorDataClient {
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            if let date = self.dateFormatter.date(from: string) ?? self.dateFormatterWithoutFractional.date(from: string) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
        })
        return aDecoder
    }()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter
    }()

    private lazy var dateFormatterWithoutFractional: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()

    private let apiURL = URL(string: "http://95.163.234.191:8000/latestData")!
    private let allDataURL = URL(string: "http://95.163.234.191:8000/allSensors?days=5")!

    private let urlSession = URLSession(configuration: .default)

    var latestData: SensorData {
        get async throws {
            let data = try await urlSession.data(for: URLRequest(url: apiURL)).0
            let decodedData: SensorData = try decoder.decode(SensorData.self, from: data)
            return decodedData
        }
    }

    var allSensorData: [SensorData] {
        get async throws {
            let data = try await urlSession.data(for: URLRequest(url: allDataURL)).0
            let decodedData: [SensorData] = try decoder.decode([SensorData].self, from: data)
            return decodedData
        }
    }
}
