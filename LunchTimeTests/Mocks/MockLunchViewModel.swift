//
// Created by jarvis on 12/26/21.
//

@testable import LunchTime

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