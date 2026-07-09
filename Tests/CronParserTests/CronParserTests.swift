//
//  CronParserTests.swift
//  Tests for SwiftCronParser
//
//  Created by David Sherlock on 7/9/26.
//

import XCTest
@testable import CronParser

final class CronParserTests: XCTestCase {

    // Fixed reference point: Thursday 2026-07-09 10:07 UTC.
    private var cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()
    private lazy var now: Date = cal.date(from: DateComponents(
        year: 2026, month: 7, day: 9, hour: 10, minute: 7))!

    func testEvery15Minutes() {
        let r = CronParser.parse("*/15 * * * *", now: now, calendar: cal)
        XCTAssertNil(r.error)
        XCTAssertEqual(r.description, "Every 15 minutes.")
        XCTAssertEqual(r.nextRuns.count, 5)
        let first = cal.dateComponents([.hour, .minute], from: r.nextRuns[0])
        XCTAssertEqual(first.hour, 10)
        XCTAssertEqual(first.minute, 15)   // 10:07 → next quarter is 10:15
        for run in r.nextRuns {
            XCTAssertTrue([0, 15, 30, 45].contains(cal.component(.minute, from: run)))
        }
    }

    func testDailyAtNineRollsToNextDay() {
        let r = CronParser.parse("0 9 * * *", now: now, calendar: cal)
        XCTAssertNil(r.error)
        let c = cal.dateComponents([.day, .hour, .minute], from: r.nextRuns[0])
        XCTAssertEqual(c.hour, 9)
        XCTAssertEqual(c.minute, 0)
        XCTAssertEqual(c.day, 10)   // 09:00 already passed today → tomorrow
    }

    func testMinuteList() {
        let r = CronParser.parse("0,30 * * * *", now: now, calendar: cal)
        XCTAssertNil(r.error)
        for run in r.nextRuns {
            XCTAssertTrue([0, 30].contains(cal.component(.minute, from: run)))
        }
    }

    func testWeekdayMondayOnly() {
        let r = CronParser.parse("0 0 * * 1", now: now, calendar: cal)
        XCTAssertNil(r.error)
        XCTAssertFalse(r.nextRuns.isEmpty)
        for run in r.nextRuns {
            XCTAssertEqual(cal.component(.weekday, from: run), 2)   // Calendar: 1=Sun, 2=Mon
            XCTAssertEqual(cal.component(.hour, from: run), 0)
            XCTAssertEqual(cal.component(.minute, from: run), 0)
        }
    }

    func testFieldsAreLabeled() {
        let r = CronParser.parse("0 9 * * 1", now: now, calendar: cal)
        XCTAssertEqual(r.fields.map(\.name), ["Minute", "Hour", "Day", "Month", "Week"])
        XCTAssertEqual(r.fields.map(\.value), ["0", "9", "*", "*", "1"])
    }

    func testWrongFieldCountIsAnError() {
        let r = CronParser.parse("* * * *", now: now, calendar: cal)
        XCTAssertNotNil(r.error)
        XCTAssertTrue(r.nextRuns.isEmpty)
    }

    func testOutOfRangeFieldIsAnError() {
        let r = CronParser.parse("99 * * * *", now: now, calendar: cal)   // minute 99 > 59
        XCTAssertNotNil(r.error)
    }

    func testEveryMinuteDescription() {
        XCTAssertEqual(CronParser.parse("* * * * *", now: now, calendar: cal).description, "Every minute.")
    }
}
