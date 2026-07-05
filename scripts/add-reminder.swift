// add-reminder.swift
//
// Small EventKit CLI for creating reminders with notes intact. Written
// after AppleScript's Reminders scripting bridge and Apple's Shortcuts
// GUI both failed to persist the "body" property reliably on this Mac
// (macOS 14.6). EventKit through Swift is the canonical path.
//
// Build:
//   swiftc -O add-reminder.swift -o add-reminder
//
// Usage:
//   ./add-reminder "List Name" "Task Title" "Optional note body"
//
// Exit codes:
//   0  reminder created
//   1  argument or permission problem
//   2  list not found
//   3  save failure

import Foundation
import EventKit

func die(_ code: Int32, _ msg: String) -> Never {
    FileHandle.standardError.write((msg + "\n").data(using: .utf8)!)
    exit(code)
}

let args = CommandLine.arguments
if args.count < 3 || args.count > 4 {
    die(1, "usage: add-reminder <list> <title> [notes]")
}
let listName = args[1]
let title = args[2]
let notes = args.count == 4 ? args[3] : ""

let store = EKEventStore()

// EventKit access model changed in macOS 14: use requestFullAccessToReminders.
let sema = DispatchSemaphore(value: 0)
var granted = false
var accessErr: Error?

store.requestFullAccessToReminders { g, e in
    granted = g
    accessErr = e
    sema.signal()
}
sema.wait()

if !granted {
    let detail = accessErr.map { " (\($0.localizedDescription))" } ?? ""
    die(1, "Reminders access not granted\(detail). Approve in System Settings > Privacy & Security > Reminders.")
}

// Find the calendar (a Reminders list is an EKCalendar with type .reminder)
let calendars = store.calendars(for: .reminder)
guard let cal = calendars.first(where: { $0.title == listName }) else {
    die(2, "list not found: \(listName)")
}

let r = EKReminder(eventStore: store)
r.calendar = cal
r.title = title
if !notes.isEmpty {
    r.notes = notes
}

do {
    try store.save(r, commit: true)
} catch {
    die(3, "save failed: \(error.localizedDescription)")
}

print("OK \(r.calendarItemIdentifier)")
