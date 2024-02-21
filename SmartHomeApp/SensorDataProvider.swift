import Combine
import Foundation

final class SensorDataProvider: ObservableObject {

    @MainActor @Published var latestData: LatestData?
    @MainActor @Published var allSensorsData: [SensorData] = []
    @MainActor @Published var waterTempDara: [BoilerData] = []
    @MainActor @Published var boilerRunData: [BoilerRunData] = []
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

    func fetchAllData(days: Int) async throws {

        var dayComponent = DateComponents()
        dayComponent.day = -days
        let theCalendar = Calendar.current
        let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())

        let allData = try await client.allSensorData(from: nextDate!, to: .nextDay)
        let allBoilerData = try await client.allBoilerData(from: nextDate!, to: .nextDay)
        let boilerRunningData = await calculateBoilerRunData(boilerData: allBoilerData)
        await MainActor.run(body: {
            self.allSensorsData = allData
            self.waterTempDara = allBoilerData
            self.boilerRunData = boilerRunningData
        })
    }

    func calculateBoilerRunData(boilerData: [BoilerData]) async -> [BoilerRunData] {
        var results = [BoilerRunData]()
        var currentData: BoilerRunData?
        boilerData.forEach { data in
            guard data.isBoilerRunning else {
                if var currentData {
                    currentData.endTime = data.time
                    results.append(currentData)
                }
                currentData = nil
                return
            }
            if currentData == nil {
                currentData = BoilerRunData(startTime: data.time, endTime: data.time)
            }
        }
        return results
    }

    // TODO: - Calculate average boiler running time
//    func calculateAverageBoilerRunData(boilerData: [BoilerRunData]) -> [BoilerAverageRunData] {
//        var currentTime: Date = .distantPast
//        var results = [BoilerAverageRunData]()
//
//        return results
//    }
}

extension Date {
    static var nextDay: Date {
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        let nextDate = theCalendar.date(byAdding: dayComponent, to: .now)
        return nextDate ?? .now
    }
}

extension Date {
    func startOfHour() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)!
    }

    func startOfNextHour() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour! += 1
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)!
    }

}
