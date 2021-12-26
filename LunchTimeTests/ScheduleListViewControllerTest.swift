//
//  ScheduleListViewControllerTest.swift
//  LunchTimeTests
//
//  Created by jarvis on 12/26/21.
//
//

import XCTest
@testable import LunchTime

class ScheduleListViewControllerTest: XCTestCase {
    func test__readsMenusFromViewModel() {
        let mockLunchViewModel = MockLunchViewModel()
        mockLunchViewModel.nextMenus = []
        let subject = ScheduleViewController(
                viewModel: mockLunchViewModel,
                dispatchQueue: MockDispatchQueue()
        )

        XCTAssertEqual(subject.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }

    func test__viewDidLoad__willLoadMenus__success__reloadTableView() {
        let mockLunchViewModel = MockLunchViewModel()
        mockLunchViewModel.nextMenus = [
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
        ]
        mockLunchViewModel.nextGetMenusResult = Result.success(true)
        let mockDispatchQueue = MockDispatchQueue()
        let subject = ScheduleViewController(
                viewModel: mockLunchViewModel,
                dispatchQueue: mockDispatchQueue
        )

        subject.viewDidLoad()

        XCTAssertTrue(mockLunchViewModel.didGetMenus)
        XCTAssertTrue(mockDispatchQueue.didAsync)
        XCTAssertEqual(subject.tableView(UITableView(), numberOfRowsInSection: 0), 4)
    }

    func test__viewDidLoad__willLoadMenus__failure__doNothing() {
        let mockLunchViewModel = MockLunchViewModel()
        mockLunchViewModel.nextMenus = [
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
        ]
        mockLunchViewModel.nextGetMenusResult = Result.success(false)
        let mockDispatchQueue = MockDispatchQueue()
        let subject = ScheduleViewController(
                viewModel: mockLunchViewModel,
                dispatchQueue: mockDispatchQueue
        )

        subject.viewDidLoad()

        mockLunchViewModel.nextMenus = []
        subject.viewDidLoad()

        XCTAssertTrue(mockLunchViewModel.didGetMenus)
        XCTAssertFalse(mockDispatchQueue.didAsync)
        XCTAssertEqual(subject.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }

    func test__viewDidLoad__willLoadMenus__error__doNothing() {
        let mockLunchViewModel = MockLunchViewModel()
        mockLunchViewModel.nextMenus = [
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
            DailyMenu(id: "", menu: ""),
        ]
        mockLunchViewModel.nextGetMenusResult = Result.failure(NSError(domain: "doesn't matter", code: -1))
        let mockDispatchQueue = MockDispatchQueue()
        let subject = ScheduleViewController(
                viewModel: mockLunchViewModel,
                dispatchQueue: mockDispatchQueue
        )

        subject.viewDidLoad()

        mockLunchViewModel.nextMenus = []
        subject.viewDidLoad()

        XCTAssertTrue(mockLunchViewModel.didGetMenus)
        XCTAssertFalse(mockDispatchQueue.didAsync)
        XCTAssertEqual(subject.tableView(UITableView(), numberOfRowsInSection: 0), 0)
    }
}

class MockLunchViewModel: LunchViewModel {
    var nextMenus: [DailyMenu]?

    var menus: [DailyMenu] {
        get {
            nextMenus!
        }
    }

    var nextGetMenusResult: Result<Bool, Error>?
    var didGetMenus = false

    func getMenus(page: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        didGetMenus = true

        guard let nextGetMenusResult = nextGetMenusResult else {
            fatalError("Next result not set")
        }

        completion(nextGetMenusResult)
    }
}
