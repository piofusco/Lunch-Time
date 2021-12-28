//
//  LunchTimeViewModelTest.swift
//  LunchTimeTests
//
//  Created by jarvis on 12/26/21.
//
//

import XCTest
@testable import LunchTime

class LunchTimeViewModelTest: XCTestCase {
    func test__init__preloadsDaysFromStartDate() {
        let subject1 = CalendarViewModel(startDate: MONDAY_DECEMBER_27_2021)

        XCTAssertEqual(subject1.days.count, 34)

        let subject2 = CalendarViewModel(startDate: SATURDAY_JANUARY_01_2022)

        XCTAssertEqual(subject2.days.count, 37)
    }

    func test__numberOfWeeksInStartDate() {
        let subject1 = CalendarViewModel(startDate: MONDAY_DECEMBER_27_2021)

        XCTAssertEqual(subject1.numberOfWeeksInStartDate, 5)

        let subject2 = CalendarViewModel(startDate: SATURDAY_JANUARY_01_2022)

        XCTAssertEqual(subject2.numberOfWeeksInStartDate, 6)
    }

    func test__loadDaysOfNextMonth() {
        let subject = CalendarViewModel(startDate: MONDAY_DECEMBER_27_2021)

        subject.loadDaysOfNextMonth()

        XCTAssertEqual(subject.days.count, 65)

        subject.loadDaysOfNextMonth()

        XCTAssertEqual(subject.days.count, 93)
    }

    func test__nextMenuItem__returnsInOrderBelow() {
        let subject = CalendarViewModel(startDate: MONDAY_DECEMBER_27_2021)

        XCTAssertEqual(subject.days[1].menu, Menu.chickenAndWaffles)
        XCTAssertEqual(subject.days[2].menu, Menu.tacos)
        XCTAssertEqual(subject.days[3].menu, Menu.curry)
        XCTAssertEqual(subject.days[4].menu, Menu.pizza)
        XCTAssertEqual(subject.days[5].menu, Menu.sushi)
        XCTAssertNil(subject.days[6].menu)
        XCTAssertNil(subject.days[7].menu)
        XCTAssertEqual(subject.days[8].menu, Menu.breakfast)
        XCTAssertEqual(subject.days[9].menu, Menu.hamburgers)
        XCTAssertEqual(subject.days[10].menu, Menu.spaghetti)
        XCTAssertEqual(subject.days[11].menu, Menu.salmon)
        XCTAssertEqual(subject.days[12].menu, Menu.sandwiches)
        XCTAssertNil(subject.days[13].menu)
        XCTAssertNil(subject.days[14].menu)
        XCTAssertEqual(subject.days[15].menu, Menu.chickenAndWaffles)
    }
}

fileprivate let MONDAY_DECEMBER_27_2021 = dateFromString("2021-12-27")
fileprivate let SATURDAY_JANUARY_01_2022 = dateFromString("2022-01-01")

fileprivate func dateFromString(_ date: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    guard let date = formatter.date(from: date) else {
        fatalError("Invalid string")
    }

    return date
}
