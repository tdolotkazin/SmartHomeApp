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
    private lazy var queryDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private let apiURL = URL(string: "http://95.163.234.191:8000/latestData")!
    private func allDataURL(from: String, to: String) -> URL {
        URL(string: "http://95.163.234.191:8000/allSensors?from=\(from)&to=\(to)")!
    }

    private func allBoilerDataURL(from: String, to: String) -> URL {
        URL(string: "http://95.163.234.191:8000/allBoiler?from=\(from)&to=\(to)")!
    }

    private let urlSession = URLSession(configuration: .default)

    var latestData: LatestData {
        get async throws {
            let data = try await urlSession.data(for: URLRequest(url: apiURL)).0
            let decodedData: LatestData = try decoder.decode(LatestData.self, from: data)
            return decodedData
        }
    }

    func allSensorData(from: Date, to: Date) async throws -> [SensorData] {
        let fromString = queryDateFormatter.string(from: from)
        let toString = queryDateFormatter.string(from: to)
        let data = try await urlSession.data(for: URLRequest(url: allDataURL(from: fromString, to: toString))).0
        let decodedData: [SensorData] = try decoder.decode([SensorData].self, from: data)
        return decodedData
    }

    func allBoilerData(from: Date, to: Date) async throws -> [BoilerData] {
        let fromString = queryDateFormatter.string(from: from)
        let toString = queryDateFormatter.string(from: to)
        let data = try await urlSession.data(for: URLRequest(url: allBoilerDataURL(from: fromString, to: toString))).0
        let decodedData: [BoilerData] = try decoder.decode([BoilerData].self, from: data)
        return decodedData
    }
}
