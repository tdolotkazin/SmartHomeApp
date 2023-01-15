import SwiftUI
import Charts

struct AllDataView: View {

    @EnvironmentObject var provider: SensorDataProvider
    @State var isLoading = false

    var body: some View {
        Chart(provider.allData) {
            LineMark(
                x: .value("Time", $0.time),
                y: .value("Temp", $0.temperature))
        }
        .frame(height: 450)
        .chartXAxis(content: {
            AxisMarks(values: .stride(by: .hour, count: 4, calendar: .current)) { value in
                let date = value.as(Date.self)
                AxisGridLine(stroke: .some(.init()))
                AxisValueLabel(anchor: .top) {
                    Text(DateFormatter.allDataDateFormatter.string(from: date!))
                }
            }
        })
        .task {
            await fetchAllData()
        }
    }

    func fetchAllData() async {
        isLoading = true
        do {
            try await provider.fetchAllData()
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
