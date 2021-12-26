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
    func test__menusInitializeToZero() {
        let mockLunchAPI = MockLunchAPI()
        let subject = GustoViewModel(api: mockLunchAPI)

        XCTAssertEqual(subject.menus.count, 0)
    }

    func test__getMenus__success__updateMenus__callDelegate() {
        let mockLunchAPI = MockLunchAPI()
        mockLunchAPI.nextResult = Result.success([
            DailyMenu(id: "0", menu: "menu 0"),
            DailyMenu(id: "1", menu: "menu 1")
        ])
        let subject = GustoViewModel(api: mockLunchAPI)
        var completionDidRun = false

        subject.getMenus(page: 99) { result in
            switch result {
            case .success(_): completionDidRun = true
            case .failure(_): XCTFail("Should succeed")
            }
        }

        XCTAssertTrue(completionDidRun)
        XCTAssertEqual(mockLunchAPI.lastPage, 99)
        XCTAssertEqual(subject.menus.count, 2)
    }

    func test__getMenus__failure__doNotUpdateMenus__doNotCallDelegate() {
        let mockLunchAPI = MockLunchAPI()
        mockLunchAPI.nextResult = Result.failure(NSError(domain: "doesn't matter", code: -1))
        let subject = GustoViewModel(api: mockLunchAPI)
        var completionDidRun = false

        subject.getMenus(page: 99) { result in
            switch result {
            case .success(_):XCTFail("Should succeed")
            case .failure(_): completionDidRun = true
            }
        }

        XCTAssertTrue(completionDidRun)
        XCTAssertEqual(mockLunchAPI.lastPage, 99)
        XCTAssertEqual(subject.menus.count, 0)
    }
}

class MockLunchAPI: LunchAPI {
    var nextResult: Result<[DailyMenu], Error>?

    var lastPage: Int?

    func getMenus(page: Int, completion: @escaping (Result<[DailyMenu], Error>) -> ()) {
        lastPage = page

        guard let nextResult = nextResult else { fatalError("next result not set") }

        completion(nextResult)
    }
}
