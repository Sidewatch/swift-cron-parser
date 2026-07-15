# Swift Cron Parser

A tiny, dependency-free parser for standard 5-field cron expressions — into labeled fields, a human-readable description, and the next run times. Pure Foundation, zero dependencies, and deterministic: you pass in the time and calendar, so results are fully testable and time-zone explicit.

## Features

- ⏰ **One-call parsing** — `CronParser.parse(_:now:calendar:)` takes a `minute hour day month weekday` expression and returns a `CronParser.Result`
- 📝 **Human description** — `Result.description`, e.g. `"Every 15 minutes."`, `"At minute 0, hour 9, on Monday."`
- 🔮 **Next run times** — `Result.nextRuns` holds the next 5 fire dates; an empty array with a `nil` error means the expression parses but never fires (the scan covers an 8-year horizon, enough for any satisfiable schedule)
- 🏷️ **Labeled fields** — `Result.fields` returns the five `(name, value)` pairs in order (Minute, Hour, Day, Month, Week)
- 🧮 **Field syntax** — `*`, `*/n`, `a-b`, `a-b/n`, `a,b`, and single values; weekday `0` and `7` both mean Sunday
- 🗓️ **Vixie-cron semantics** — day-of-month and day-of-week are OR-ed when both are restricted (a field counts as restricted unless it starts with `*`)
- 🧪 **Deterministic** — `now` and `Calendar` are injected; no hidden clock, no hidden time zone
- 🪶 **Zero dependencies** — Foundation only
- 🍎 **Cross-platform** — iOS, macOS, tvOS, watchOS, visionOS

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+ / visionOS 1.0+
- Swift 5.9+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-cron-parser.git", from: "1.0.0")
]
```

## Usage

```swift
import CronParser

// Weekdays, 9-to-5, every 15 minutes.
let result = CronParser.parse("*/15 9-17 * * 1-5", now: Date(), calendar: .current)

// Invalid expressions come back with a populated `error`, never a throw.
if let error = result.error {
    print("Invalid:", error)
} else {
    // "Every 15 minutes, hours 9 through 17, Monday through Friday."
    print(result.description)

    // The five fields, labeled and in order.
    for (name, value) in result.fields {
        print("\(name): \(value)")   // Minute: */15, Hour: 9-17, …
    }

    // The next 5 fire times after `now` (empty = never fires).
    for run in result.nextRuns {
        print(run)
    }
}
```

## License

MIT
