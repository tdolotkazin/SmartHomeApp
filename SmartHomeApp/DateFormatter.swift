import Foundation

extension DateFormatter {
    static var allDataDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd"        
        return formatter
    }()

    static var allDataTimeFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
