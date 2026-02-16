# Pical Working Notes

## MVP Clarifications (From Cam, 2026-02-17)
- **Platform**: iOS 17+ (iPhone only) [Cam specified “iOS 26 only”; interpret as targeting latest iOS SDK, phone form-factor].
- **Accessibility**: No special requirements for MVP.
- **Storage**: Engineer’s choice (any straightforward local store is acceptable).
- **Event Schema**: `title`, `timestamp`, `location`, `notes`.
- **Recurring Events**: Only weekly or monthly patterns are required. “Special events” = one-off events.
- **Views**: Agenda view only (list of events; one line per event). No onboarding screen yet.
- **Layout**: Horizontal bars concept deferred; agenda rows suffice. No overlapping stacks or priority indicators for now.
- **Gestures**: Use discretion; inline editing via sheet is acceptable.
- **Validation**: Use reasonable intuition; no undo/redo needed.
- **Visual Identity**: Default SwiftUI typography/colors for now; bird theming comes later.
- **Data Portability**: No import/export or backup considerations yet.
- **Testing**: Provide SwiftUI previews and unit tests (no snapshot/UI tests).

## Next Steps
- Create a working branch before coding when greenlit.
- Begin with data model + local persistence choice aligned to “simple & obvious” ethos.
- Build agenda list view with inline edit/create workflows and previews/tests.
