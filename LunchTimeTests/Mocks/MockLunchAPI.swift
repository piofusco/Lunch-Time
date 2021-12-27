//
// Created by jarvis on 12/26/21.
//

import Foundation
@testable import LunchTime

class MockLunchAPI: LunchAPI {
    var nextResult: Result<[Menu], Error>?

    func getMenus(completion: @escaping (Result<[Menu], Error>) -> ()) {
        guard let nextResult = nextResult else { fatalError("next result not set") }

        completion(nextResult)
    }
}