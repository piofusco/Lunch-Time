//
// Created by jarvis on 12/26/21.
//

import Foundation

@testable import LunchTime

class MockLunchViewModel: LunchViewModel {

    var nextGetMenusResult: Result<Bool, Error>?
    var didGetMenus = false

    func getMenusFromAPI(page: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        didGetMenus = true

        guard let nextGetMenusResult = nextGetMenusResult else {
            fatalError("Next result not set")
        }

        completion(nextGetMenusResult)
    }

    var nextMenus: [Menu]?
    var menus: [Menu] {
        get {
            nextMenus!
        }
    }

    func getMenusForNext2Weeks(date: Date, completion: @escaping (Result<Bool, Error>) -> ()) {

    }
}