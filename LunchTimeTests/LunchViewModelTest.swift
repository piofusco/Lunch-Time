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
    func test__getMenusFromAPI__success__updateMenus() {
        let mockLunchAPI = MockLunchAPI()
        mockLunchAPI.nextResult = Result.success([
            Menu(dayOfTheWeek: "0", description: "menu 0"),
            Menu(dayOfTheWeek: "1", description: "menu 1")
        ])
        let subject = GustoViewModel(api: mockLunchAPI)
        var completionDidRun = false

        subject.getMenusFromAPI { result in
            switch result {
            case .success(_): completionDidRun = true
            case .failure(_): XCTFail("Should succeed")
            }
        }

        XCTAssertTrue(completionDidRun)
        XCTAssertEqual(subject.menus.count, 2)
    }

    func test__getMenusFromAPI__failure__doNotUpdateMenus() {
        let mockLunchAPI = MockLunchAPI()
        mockLunchAPI.nextResult = Result.failure(NSError(domain: "doesn't matter", code: -1))
        let subject = GustoViewModel(api: mockLunchAPI)
        var completionDidRun = false

        subject.getMenusFromAPI { result in
            switch result {
            case .success(_): XCTFail("Should not succeed")
            case .failure(_): completionDidRun = true
            }
        }

        XCTAssertTrue(completionDidRun)
        XCTAssertEqual(subject.menus.count, 0)
    }
}
