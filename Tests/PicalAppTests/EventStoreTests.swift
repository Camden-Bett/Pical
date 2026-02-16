import XCTest
@testable import PicalApp

final class EventStoreTests: XCTestCase {
    @MainActor
    func testWeeklyRecurrenceGeneratesOccurrences() {
        var components = DateComponents()
        components.year = 2026
        components.month = 2
        components.day = 16
        components.hour = 9
        components.minute = 0

        let calendar = Calendar(identifier: .gregorian)
        let start = calendar.date(from: components) ?? .now
        let event = EventRecord(
            title: "Standup",
            timestamp: start,
            recurrence: RecurrenceRule(frequency: .weekly)
        )

        let rangeEnd = calendar.date(byAdding: .day, value: 15, to: start) ?? start
        let occurrences = event.occurrences(in: start...rangeEnd, calendar: calendar)

        XCTAssertEqual(occurrences.count, 3)
        XCTAssertTrue(occurrences.allSatisfy { $0.eventID == event.id })
    }

    @MainActor
    func testStoreUpsertAndDeleteFlow() async {
        let persistence = EventPersistence.inMemory()
        let store = EventStore(persistence: persistence)
        await store.refresh()

        let newEvent = EventRecord(title: "Interview", timestamp: .now)
        await store.upsert(newEvent)
        XCTAssertEqual(store.events.count, 1)

        await store.delete(eventID: newEvent.id)
        XCTAssertTrue(store.events.isEmpty)
    }
}
