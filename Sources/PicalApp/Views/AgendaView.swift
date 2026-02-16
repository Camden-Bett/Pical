import SwiftUI

struct AgendaView: View {
    @ObservedObject var store: EventStore
    @State private var editorState: EventEditorState?
    @State private var daysAhead: Int = 21

    var body: some View {
        NavigationStack {
            Group {
                if store.agendaSections(daysAhead: daysAhead).isEmpty {
                    EmptyStateView(action: startCreating)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.agendaBackground)
                } else {
                    List {
                        ForEach(store.agendaSections(daysAhead: daysAhead)) { section in
                            Section(header: Text(sectionHeader(for: section.date))) {
                                ForEach(section.events) { occurrence in
                                    EventRowView(occurrence: occurrence)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            openEditor(for: occurrence.eventID)
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                Task { await store.delete(eventID: occurrence.eventID) }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                    #if os(iOS)
                    .listStyle(.insetGrouped)
                    #else
                    .listStyle(.inset)
                    #endif
                }
            }
            .navigationTitle("Pical")
            .toolbar {
                #if os(iOS)
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: startCreating) {
                        Label("New event", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Picker("Range", selection: $daysAhead) {
                        Text("1W").tag(7)
                        Text("2W").tag(14)
                        Text("3W").tag(21)
                        Text("1M").tag(30)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 160)
                }
                #else
                ToolbarItemGroup(placement: .automatic) {
                    Picker("Range", selection: $daysAhead) {
                        Text("1W").tag(7)
                        Text("2W").tag(14)
                        Text("3W").tag(21)
                        Text("1M").tag(30)
                    }
                    Button(action: startCreating) {
                        Label("New event", systemImage: "plus")
                    }
                }
                #endif
            }
        }
        .sheet(item: $editorState) { editor in
            NavigationStack {
                EventEditorView(
                    draft: editor.draft,
                    onCommit: { record in
                        Task { await store.upsert(record) }
                        editorState = nil
                    },
                    onDelete: editor.allowsDeletion ? {
                        if let id = editor.draft.id {
                            Task { await store.delete(eventID: id) }
                        }
                        editorState = nil
                    } : nil
                )
            }
            .presentationDetents([.medium, .large])
        }
    }

    private func startCreating() {
        editorState = EventEditorState(draft: EventDraft())
    }

    private func openEditor(for eventID: UUID) {
        guard let existing = store.event(id: eventID) else { return }
        editorState = EventEditorState(draft: EventDraft(event: existing))
    }

    private func sectionHeader(for date: Date) -> String {
        DateFormatter.agendaDayFormatter.string(from: date)
    }
}

struct AgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaView(store: .preview)
    }
}
