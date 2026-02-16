import Foundation

enum DateFormatterCatalog {
    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static let day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()

    static let shortDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
}

extension DateFormatter {
    static var agendaDayFormatter: DateFormatter { DateFormatterCatalog.day }
    static var agendaTimeFormatter: DateFormatter { DateFormatterCatalog.time }
}

extension Date {
    func isSameDay(as other: Date, calendar: Calendar = .autoupdatingCurrent) -> Bool {
        calendar.isDate(self, inSameDayAs: other)
    }
}
