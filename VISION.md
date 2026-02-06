# Pical — Vision & Constraints

## What Pical Is
Pical is a **friendly, local-first calendar app** designed to feel like a helpful companion rather than a sterile productivity tool.

It emphasizes:
- Clarity over density
- Warmth over minimalism
- Habit and memory over optimization

Pical should feel inviting to open, forgiving to use, and easy to trust.

---

## Core Principles

### 1. Friendly, Not Clinical
Pical avoids harsh alerts, aggressive productivity language, or corporate UI tropes.

Tone should be:
- Gentle
- Encouraging
- Conversational (but not chatty or cutesy)

If Pical reminds you of something, it should feel like a nudge from a helpful assistant, not a warning from a system.

---

### 2. Local-First by Default
Pical runs locally and stores user data locally.

- No cloud dependency required
- No account required
- No forced sign-in
- Sync is optional and future-considered, not foundational

Users should be able to trust that their calendar exists **on their machine**, not someone else’s server.

---

### 3. Simple, Obvious Code
The codebase should favor:
- Readability over cleverness
- Fewer dependencies over abstraction layers
- Straightforward data models

If something can be done in a boring, obvious way, that is preferred.

---

### 4. Horizontal Time Representation
**Important UI constraint:**

- Events are represented as **horizontal bars**, not vertical columns.
- Time flows top → bottom, not left → right. This is for easy viewing on mobile.
- The soonest events should be at the top, and the farthest out at the bottom.
- This is a deliberate design choice for legibility and calmness.

Any weekly or daily view should respect this orientation.

---

### 5. Visual Identity
Pical has a loose **Pica Pica bird theme**.

This does *not* mean:
- Literal bird imagery everywhere
- Gimmicks or excessive theming

It *does* mean:
- Subtle personality
- A sense of curiosity and order
- Warm neutrals with occasional iridescent or playful accents
- The UI should not be minimalistic, but not overdone. Shoot for tasteful.

---

## What Pical Is Not
Pical is not:
- A task manager replacement
- A project management tool
- A fully collaborative enterprise calendar
- A hyper-minimal “blank grid” calendar
- A data-harvesting productivity platform

If a feature pushes Pical toward those directions, it should be questioned.

---

## MVP Scope (Initial)
The first usable version of Pical should aim for:

- Create, edit, and delete events
- Special event and recurring event views
- Horizontal event bars
- Local persistence
- Friendly but restrained UI

Anything beyond this is optional and should be added intentionally.

---

## Future Ideas (Non-Binding)
These are *not requirements*, only possibilities:

- Optional reminders with gentle phrasing
- Light mascot presence (subtle, ignorable)
- Optional export/import
- Optional sync, designed carefully and explicitly

Do not build toward these unless the core experience feels solid.

---

## Guiding Question
When unsure about a change, ask:

> “Does this make Pical feel more like a calm, helpful companion — or more like a system demanding attention?”

Prefer the former.
