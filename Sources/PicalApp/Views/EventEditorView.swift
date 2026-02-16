import SwiftUI

struct EventEditorState: Identifiable, Equatable {
    let id = UUID()
    var draft: EventDraft

    var allowsDeletion: Bool { draft.id != nil }
}

struct EventDraft: Identifiable, Equatable {
    enum RecurrenceChoice: String, CaseIterable, Identifiable {
        case none
        case weekly
        case monthly

        var id: String { rawValue }

        var label: String {
            switch self {
            case .none: return "None"
            case .weekly: return "Weekly"
            case .monthly: return "Monthly"
            }
        }

        var associatedRule: RecurrenceRule? {
            switch self {
            case .none: return nil
            case .weekly: return RecurrenceRule(frequency: .weekly)
            case .monthly: return RecurrenceRule(frequency: .monthly)
            }
        }
    }

    var id: UUID?
    var title: String
    var timestamp: Date
    var duration: TimeInterval
    var location: String
    var notes: String
    var choice: RecurrenceChoice
    var createdAt: Date

    init(
        id: UUID? = nil,
        title: String = "",
        timestamp: Date = .now,
        duration: TimeInterval = 60 * 60,
        location: String = "",
        notes: String = "",
        choice: RecurrenceChoice = .none,
        createdAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.timestamp = timestamp
        self.duration = duration
        self.location = location
        self.notes = notes
        self.choice = choice
        self.createdAt = createdAt
    }

    init(event: EventRecord) {
        self.id = event.id
        self.title = event.title
        self.timestamp = event.timestamp
        self.duration = event.duration
        self.location = event.location
        self.notes = event.notes
        self.createdAt = event.createdAt
        if let recurrence = event.recurrence {
            switch recurrence.frequency {
            case .weekly: self.choice = .weekly
            case .monthly: self.choice = .monthly
            }
        } else {
            self.choice = .none
        }
    }

    func materialize() -> EventRecord {
        let createdValue = id == nil ? Date() : createdAt
        return EventRecord(
            id: id ?? UUID(),
            title: title.trimmed,
            timestamp: timestamp,
            duration: duration,
            location: location.trimmed,
            notes: notes.trimmed,
            recurrence: choice.associatedRule,
            createdAt: createdValue,
            updatedAt: .now
        )
    }
}

struct EventEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: EventDraft

    var onCommit: (EventRecord) -> Void
    var onDelete: (() -> Void)?

    private let durationOptions: [TimeInterval] = [30, 45, 60, 90, 120, 180].map { $0 * 60 }

    init(
        draft: EventDraft,
        onCommit: @escaping (EventRecord) -> Void,
        onDelete: (() -> Void)? = nil
    ) {
        self._draft = State(initialValue: draft)
        self.onCommit = onCommit
        self.onDelete = onDelete
    }

    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $draft.title)
                DatePicker("Start", selection: $draft.timestamp)
                Picker("Duration", selection: $draft.duration) {
                    ForEach(durationOptions, id: \.self) { option in
                        Text(durationLabel(for: option)).tag(option)
                    }
                }
                Picker("Repeats", selection: $draft.choice) {
                    ForEach(EventDraft.RecurrenceChoice.allCases) { choice in
                        Text(choice.label).tag(choice)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Place & Notes") {
                TextField("Location", text: $draft.location)
                TextEditor(text: $draft.notes)
                    .frame(minHeight: 120)
            }

            if let onDelete {
                Section {
                    Button(role: .destructive, action: {
                        onDelete()
                        dismiss()
                    }) {
                        Label("Delete Event", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle(draft.id == nil ? "New Event" : "Edit Event")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onCommit(draft.materialize())
                    dismiss()
                }
                .disabled(draft.title.trimmed.isEmpty)
            }
        }
    }

    private func durationLabel(for interval: TimeInterval) -> String {
        let minutes = Int(interval / 60)
        return "\(minutes) min"
    }
}

struct EventEditorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EventEditorView(draft: EventDraft(event: EventRecord.samples[0])) { _ in } onDelete: {}
        }
    }
}
