import Foundation

struct SensorData: Decodable, Identifiable {

    var id: Date {
        return time
    }
    var temperature: Double
    var humidity: Double
    var time: Date

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "hum"
        case time = "time"
    }
}
