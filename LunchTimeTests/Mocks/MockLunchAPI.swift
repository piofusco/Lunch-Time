//
// Created by jarvis on 12/26/21.
//

import Foundation
@testable import LunchTime

class MockLunchAPI: LunchAPI {
    var nextResult: Result<[Menu], Error>?

    var lastPage: Int?

    func getMenus(page: Int, completion: @escaping (Result<[Menu], Error>) -> ()) {
        lastPage = page

        guard let nextResult = nextResult else { fatalError("next result not set") }

        completion(nextResult)
    }
}