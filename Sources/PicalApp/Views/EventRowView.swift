import SwiftUI

struct EventRowView: View {
    let occurrence: EventOccurrence

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(occurrence.title)
                    .font(.headline)
                Text(timeRangeText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if !occurrence.location.trimmed.isEmpty {
                    Label(occurrence.location, systemImage: "mappin.and.ellipse")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                if !occurrence.notes.trimmed.isEmpty {
                    Text(occurrence.notes)
                        .font(.caption)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 12)
            if occurrence.isRecurring {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundStyle(.tertiary)
                    .accessibilityLabel("Recurring event")
            }
        }
        .padding(.vertical, 8)
    }

    private var timeRangeText: String {
        let start = DateFormatter.agendaTimeFormatter.string(from: occurrence.startDate)
        let end = DateFormatter.agendaTimeFormatter.string(from: occurrence.endDate)
        return "\(start) – \(end)"
    }
}

struct EventRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EventRowView(occurrence: EventOccurrence(event: EventRecord.samples[0], startDate: .now))
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.inset)
        #endif
    }
}
