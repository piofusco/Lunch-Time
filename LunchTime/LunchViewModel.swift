//
// Created by jarvis on 12/26/21.
//

import Foundation

protocol LunchViewModel {
    var menus: [Menu] { get }

    func getMenusFromAPI(completion: @escaping (Result<Bool, Error>) -> ())
}

class GustoViewModel: LunchViewModel {
    private let api: LunchAPI

    init(api: LunchAPI) {
        self.api = api
    }

    private(set) var menus: [Menu] = []

    func getMenusFromAPI(completion: @escaping (Result<Bool, Error>) -> ()) {
        api.getMenus { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let menus):
                self.menus = menus
                completion(Result.success(true))
            case .failure(let error): completion(Result.failure(error))
            }
        }
    }
}


