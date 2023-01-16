import SwiftUI
import Charts

struct AllDataView: View {

    @EnvironmentObject var provider: SensorDataProvider
    @State var isLoading = false
    @State var daysFetched = 1

    var body: some View {
        VStack {
            Chart(provider.allData) {
                LineMark(
                    x: .value("Time", $0.time),
                    y: .value("Temp", $0.temperature))
            }
            .frame(height: 450)
            .chartXAxis(content: {
                AxisMarks(values: .stride(by: .hour, count: 4 * daysFetched, calendar: .current)) { value in
                    let date = value.as(Date.self)
                    AxisGridLine(stroke: .some(.init()))
                    AxisValueLabel(anchor: .top) {
                        Text(DateFormatter.allDataDateFormatter.string(from: date!))
                    }
                }
            })
            Picker(
                "Days",
                selection: $daysFetched
            ) {
                Text("1").tag(1)
                Text("2").tag(2)
                Text("3").tag(3)
                Text("4").tag(4)
            }
            .pickerStyle(.segmented)
            .onChange(of: daysFetched) { newValue in
                Task {
                    await fetchAllData(days: newValue)
                }
            }
        }
        .task {
            await fetchAllData(days: 1)
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
