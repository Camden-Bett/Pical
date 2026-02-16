import SwiftUI

@main
struct PicalApp: App {
    @StateObject private var store = EventStore()

    var body: some Scene {
        WindowGroup {
            AgendaView(store: store)
                .task {
                    if !store.isLoaded {
                        await store.refresh()
                    }
                }
        }
    }
}
