# Swift Cron Parser

A tiny, dependency-free parser for standard 5-field cron expressions — into labeled fields, a human-readable description, and the next run times. Deterministic (you pass in the time and calendar), so it's fully testable and time-zone explicit.

## Features

- ⏰ **Parse** `minute hour day month weekday` expressions
- 📝 **Human description** — e.g. `"Every 15 minutes."`, `"At minute 0, hour 9, on Monday."`
- 🔮 **Next run times** — the next 5 fire dates
- 🧮 **Field syntax** — `*`, `*/n`, `a-b`, `a-b/n`, `a,b`, and single values
- 🗓️ **Vixie-cron semantics** — day-of-month and day-of-week are OR-ed when both are restricted
- 🧪 **Deterministic** — `now` and `Calendar` are injected; no hidden clock
- 🪶 **Zero dependencies** — Foundation only
- 🍎 **Cross-platform** — iOS, macOS, tvOS, watchOS, visionOS

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+ / visionOS 1.0+
- Swift 5.9+

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/arraypress/swift-cron-parser.git", from: "1.0.0")
]
```

## Usage

```swift
import CronParser

let result = CronParser.parse("*/15 9-17 * * 1-5", now: Date(), calendar: .current)

if let error = result.error {
    print("Invalid:", error)
} else {
    print(result.description)          // "Every 15 minutes, hours 9 through 17, Monday through Friday."
    for (name, value) in result.fields { print("\(name): \(value)") }
    for run in result.nextRuns { print(run) }
}
```

## License

MIT
