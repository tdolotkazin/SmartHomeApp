import Foundation

struct SensorData: Decodable, Identifiable {

    var id: String {
        return time.ISO8601Format()
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

struct LatestData: Decodable {
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

struct BoilerData: Decodable, Identifiable {

    var id: String {
        return time.ISO8601Format()
    }
    var waterTemperature: Double
    var isBoilerRunning: Bool
    var time: Date

    enum CodingKeys: String, CodingKey {
        case waterTemperature = "waterTemp"
        case isBoilerRunning = "isRunning"
        case time = "time"
    }
}

struct BoilerRunData: Identifiable {
    var id: Date {
        return startTime
    }
    var startTime: Date
    var endTime: Date
}

struct BoilerAverageRunData: Identifiable {
    var id: Date {
        return time
    }
    var time: Date
    var averageRunning: Double
}
