import Foundation

extension DateFormatter {
    static var allDataDateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"        
        return formatter
    }()
}
