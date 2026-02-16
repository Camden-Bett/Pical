import Foundation

struct EventRecord: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var timestamp: Date
    var duration: TimeInterval
    var location: String
    var notes: String
    var recurrence: RecurrenceRule?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        timestamp: Date,
        duration: TimeInterval = 60 * 60,
        location: String = "",
        notes: String = "",
        recurrence: RecurrenceRule? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.timestamp = timestamp
        self.duration = max(15 * 60, duration)
        self.location = location
        self.notes = notes
        self.recurrence = recurrence
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

extension EventRecord {
    var endDate: Date { timestamp.addingTimeInterval(duration) }

    func updatingTimestamp(_ date: Date) -> EventRecord {
        var copy = self
        copy.timestamp = date
        copy.updatedAt = .now
        return copy
    }

    func updatingMetadata(_ transform: (inout EventRecord) -> Void) -> EventRecord {
        var copy = self
        transform(&copy)
        copy.updatedAt = .now
        return copy
    }
}

struct RecurrenceRule: Codable, Equatable, Hashable {
    enum Frequency: String, Codable, CaseIterable, Identifiable {
        case weekly
        case monthly

        var id: String { rawValue }

        var calendarComponent: Calendar.Component {
            switch self {
            case .weekly: return .weekOfYear
            case .monthly: return .month
            }
        }

        var localizedLabel: String {
            switch self {
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            }
        }
    }

    var frequency: Frequency
    var interval: Int

    init(frequency: Frequency, interval: Int = 1) {
        self.frequency = frequency
        self.interval = max(1, interval)
    }
}

struct EventOccurrence: Identifiable, Hashable {
    let id: String
    let eventID: UUID
    let title: String
    let startDate: Date
    let endDate: Date
    let location: String
    let notes: String
    let isRecurring: Bool

    init(event: EventRecord, startDate: Date) {
        self.eventID = event.id
        self.title = event.title
        self.startDate = startDate
        self.endDate = startDate.addingTimeInterval(event.duration)
        self.location = event.location
        self.notes = event.notes
        self.isRecurring = event.recurrence != nil
        self.id = event.id.uuidString + "-" + String(startDate.timeIntervalSinceReferenceDate)
    }
}

extension EventRecord {
    func occurrences(in range: ClosedRange<Date>, calendar: Calendar = .autoupdatingCurrent) -> [EventOccurrence] {
        if let recurrence {
            return recurringOccurrences(rule: recurrence, in: range, calendar: calendar)
        }

        guard range.contains(timestamp) else { return [] }
        return [EventOccurrence(event: self, startDate: timestamp)]
    }

    private func recurringOccurrences(
        rule: RecurrenceRule,
        in range: ClosedRange<Date>,
        calendar: Calendar
    ) -> [EventOccurrence] {
        var instances: [EventOccurrence] = []
        var nextDate = timestamp

        while nextDate < range.lowerBound {
            guard let advanced = calendar.date(byAdding: rule.frequency.calendarComponent, value: rule.interval, to: nextDate) else {
                return instances
            }
            nextDate = advanced
        }

        while nextDate <= range.upperBound {
            instances.append(EventOccurrence(event: self, startDate: nextDate))
            guard let advanced = calendar.date(byAdding: rule.frequency.calendarComponent, value: rule.interval, to: nextDate) else {
                break
            }
            nextDate = advanced
        }

        return instances
    }
}

struct AgendaSection: Identifiable, Hashable {
    let id: UUID = UUID()
    let date: Date
    let events: [EventOccurrence]

    var accessibilityLabel: String {
        let formatter = DateFormatter.agendaDayFormatter
        return formatter.string(from: date)
    }
}

extension EventRecord {
    static var samples: [EventRecord] {
        let calendar = Calendar.autoupdatingCurrent
        let now = calendar.startOfDay(for: .now)
        let morning = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now) ?? now
        let afternoon = calendar.date(bySettingHour: 14, minute: 0, second: 0, of: now) ?? now

        return [
            EventRecord(
                title: "Design sync",
                timestamp: morning,
                duration: 60 * 60,
                location: "Studio",
                notes: "Walk through horizontal bars",
                recurrence: RecurrenceRule(frequency: .weekly)
            ),
            EventRecord(
                title: "Grocery reset",
                timestamp: afternoon,
                duration: 45 * 60,
                location: "Neighborhood",
                notes: "Focus on produce",
                recurrence: RecurrenceRule(frequency: .weekly, interval: 2)
            ),
            EventRecord(
                title: "Orthodontist",
                timestamp: calendar.date(byAdding: .day, value: 3, to: morning) ?? morning
            )
        ]
    }
}
