import Foundation

struct SensorData: Decodable {
    var temperature: Double
    var humidity: Double
    var time: Date

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "hum"
        case time = "time"
    }
}
