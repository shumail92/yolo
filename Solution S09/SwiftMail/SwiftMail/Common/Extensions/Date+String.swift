import Foundation

extension Date {
    init?(fromString string: String, dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss") {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        guard let date = dateFormatter.date(from: string) else { return nil }
        self = date
    }
}
