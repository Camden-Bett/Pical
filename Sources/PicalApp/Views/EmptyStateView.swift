import SwiftUI

struct EmptyStateView: View {
    var action: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 48))
                .foregroundStyle(.quaternary)
            Text("Nothing scheduled yet")
                .font(.title3)
                .bold()
            Text("Add a special moment or recurring rhythm to get started.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button(action: action) {
                Label("Create your first event", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(32)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(action: {})
    }
}
