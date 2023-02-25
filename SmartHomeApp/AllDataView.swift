import SwiftUI
import Charts

struct AllDataView: View {

    @EnvironmentObject var provider: SensorDataProvider
    @State var isLoading = false
    @State var daysFetched = 1
    @State var xScaleFactor: CGFloat = 1

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                VStack {
                    Chart {
                        ForEach(provider.waterTempDara) {
                            LineMark(
                                x: .value("Time", $0.time),
                                y: .value("WaterTemp", $0.waterTemperature),
                                series: .value("Boiler", "A")
                            )
                            .foregroundStyle(.red)
                        }

                        ForEach(provider.allSensorsData) {
                            LineMark(
                                x: .value("Time", $0.time),
                                y: .value("Temp", $0.temperature),
                                series: .value("Sensor", "B")
                            )
                            .foregroundStyle(.blue)
                        }

                        ForEach(provider.boilerRunData) {
                            BarMark(xStart: .value("Time", $0.startTime),
                                    xEnd: .value("End time", $0.endTime),
                                    y: .value("Running", 10),
                                    height: .fixed(50)
                            )
                            .foregroundStyle(.green)
                        }
                    }
                    .frame(height: 450)
                    .chartXAxis(content: {
                        AxisMarks(values: .stride(by: .day, calendar: .current)) { value in
                            let date = value.as(Date.self)
                            AxisGridLine(stroke: .some(.init(lineWidth: 3)))
                            AxisValueLabel(anchor: .top) {
                                Text(DateFormatter.allDataDateFormatter.string(from: date!))
                            }
                        }
                        AxisMarks(values: .stride(by: .hour, calendar: .current)) { value in
                            let date = value.as(Date.self)
                            AxisGridLine(stroke: .some(.init()))
                            AxisValueLabel(anchor: .bottom) {
                                Text(DateFormatter.localizedString(from: date!, dateStyle: .none, timeStyle: .short))
                            }
                        }
                    })
                    .chartYScale(domain: .automatic(includesZero: false))
                }
                .frame(width: 1000 * xScaleFactor)
                .task {
                    await fetchAllData(days: 1)
                }
            }
            HStack {
                Button("Last day") {
                    daysFetched = 1
                }
                Button("Last week") {
                    daysFetched = 7
                }
                Button("Last month") {
                    daysFetched = 30
                }
                Button("Set custom dates") {

                }
            }
            .onChange(of: daysFetched) { newValue in
                Task {
                    xScaleFactor = 1
                    await fetchAllData(days: newValue)
                }
            }
            HStack {
                Button {
                    xScaleFactor = xScaleFactor * 2
                } label: {
                    Image(systemName: "plus.magnifyingglass")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                Button {
                    xScaleFactor = xScaleFactor / 2
                } label: {
                    Image(systemName: "minus.magnifyingglass")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
        }
    }

    func fetchAllData(days: Int) async {
        isLoading = true
        do {
            try await provider.fetchAllData(days: days)
        } catch {
            print(error)
        }
        isLoading = false
    }
}

struct AllDataView_Previews: PreviewProvider {
    static var previews: some View {
        AllDataView()
            .environmentObject(SensorDataProvider())
    }
}
