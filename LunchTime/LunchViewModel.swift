//
// Created by jarvis on 12/26/21.
//

import Foundation

protocol LunchViewModel {
    var menus: [DailyMenu] { get }

    func getMenus(page: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}

class GustoViewModel: LunchViewModel {
    weak var delegate: LunchViewModelDelegate?

    private let api: LunchAPI

    init(api: LunchAPI) {
        self.api = api
    }

    private(set) var menus: [DailyMenu] = []

    func getMenus(page: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        api.getMenus(page: page) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let menus): print()
                self.menus.append(contentsOf: menus)
                self.delegate?.menusDidUpdate()
                completion(Result.success(true))
            case .failure(let error): completion(Result.failure(error))
            }
        }
    }
}

protocol LunchViewModelDelegate: AnyObject {
    func menusDidUpdate()
}