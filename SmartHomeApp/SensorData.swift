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

struct LatestData: Decodable, Identifiable {
    var id: Date {
        return baseLastUpdatedTime
    }

    var temperature: Double
    var humidity: Double
    var baseLastUpdatedTime: Date

    var isBoilerRunning: Bool
    var waterTemperature: Double
    var boilerLastUpdatedTime: Date

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "hum"
        case baseLastUpdatedTime = "baseLastUpdatedTime"
        case isBoilerRunning = "isRunning"
        case waterTemperature = "waterTemp"
        case boilerLastUpdatedTime = "boilerLastUpdatedTime"
    }
}
