//
//  LunchViewModelTest.swift
//  LunchTimeTests
//
//  Created by jarvis on 12/26/21.
//
//

import XCTest
@testable import LunchTime

class LunchViewModelTest: XCTestCase {
    func test__getHardcodedMenus() {
        let subject = GustoViewModel(api: MockLunchAPI())

        let menus = subject.menus
        XCTAssertEqual(menus.count, 14)
        XCTAssertEqual(menus[0].dayOfTheWeek, "Sunday")
        XCTAssertNil(menus[0].description)
        XCTAssertEqual(menus[1].dayOfTheWeek, "Monday")
        XCTAssertEqual(menus[1].description, "Chicken and Waffles")
        XCTAssertEqual(menus[2].dayOfTheWeek, "Tuesday")
        XCTAssertEqual(menus[2].description, "Tacos")
        XCTAssertEqual(menus[3].dayOfTheWeek, "Wednesday")
        XCTAssertEqual(menus[3].description, "Curry")
        XCTAssertEqual(menus[4].dayOfTheWeek, "Thursday")
        XCTAssertEqual(menus[4].description, "Pizza")
        XCTAssertEqual(menus[5].dayOfTheWeek, "Friday")
        XCTAssertEqual(menus[5].description, "Sushi")
        XCTAssertEqual(menus[6].dayOfTheWeek, "Saturday")
        XCTAssertNil(menus[6].description)
        XCTAssertEqual(menus[7].dayOfTheWeek, "Sunday")
        XCTAssertNil(menus[7].description)
        XCTAssertEqual(menus[8].dayOfTheWeek, "Monday")
        XCTAssertEqual(menus[8].description, "Breakfast for lunch")
        XCTAssertEqual(menus[9].dayOfTheWeek, "Tuesday")
        XCTAssertEqual(menus[9].description, "Hamburgers")
        XCTAssertEqual(menus[10].dayOfTheWeek, "Wednesday")
        XCTAssertEqual(menus[10].description, "Spaghetti")
        XCTAssertEqual(menus[11].dayOfTheWeek, "Thursday")
        XCTAssertEqual(menus[11].description, "Salmon")
        XCTAssertEqual(menus[12].dayOfTheWeek, "Friday")
        XCTAssertEqual(menus[12].description, "Sandwiches")
        XCTAssertEqual(menus[13].dayOfTheWeek, "Saturday")
        XCTAssertNil(menus[13].description)
    }

    func test__getMenusFromAPI__success__updateMenus() {
        let mockLunchAPI = MockLunchAPI()
        mockLunchAPI.nextResult = Result.success([
            Menu(dayOfTheWeek: "0", description: "menu 0"),
            Menu(dayOfTheWeek: "1", description: "menu 1")
        ])
        let subject = GustoViewModel(api: mockLunchAPI)
        var completionDidRun = false

        subject.getMenusFromAPI(page: 99) { result in
            switch result {
            case .success(_): completionDidRun = true
            case .failure(_): XCTFail("Should succeed")
            }
        }

        XCTAssertTrue(completionDidRun)
        XCTAssertEqual(mockLunchAPI.lastPage, 99)
        XCTAssertEqual(subject.menus.count, 2)
    }

    func test__getMenusFromAPI__failure__doNotUpdateMenus() {
        let mockLunchAPI = MockLunchAPI()
        mockLunchAPI.nextResult = Result.failure(NSError(domain: "doesn't matter", code: -1))
        let subject = GustoViewModel(api: mockLunchAPI)
        var completionDidRun = false

        subject.getMenusFromAPI(page: 99) { result in
            switch result {
            case .success(_): XCTFail("Should not succeed")
            case .failure(_): completionDidRun = true
            }
        }

        XCTAssertTrue(completionDidRun)
        XCTAssertEqual(mockLunchAPI.lastPage, 99)
        XCTAssertEqual(subject.menus.count, 0)
    }
}
