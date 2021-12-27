//
// Created by jarvis on 12/26/21.
//

import Foundation

protocol LunchViewModel {
    var menus: [Menu] { get }

    func getMenusFromAPI(page: Int, completion: @escaping (Result<Bool, Error>) -> Void)
}

class GustoViewModel: LunchViewModel {
    private let api: LunchAPI

    init(api: LunchAPI) {
        self.api = api
    }

    private(set) var menus: [Menu] = [
        Menu(dayOfTheWeek: "Sunday", description: nil),
        Menu(dayOfTheWeek: "Monday", description: "Chicken and Waffles"),
        Menu(dayOfTheWeek: "Tuesday", description: "Tacos"),
        Menu(dayOfTheWeek: "Wednesday", description: "Curry"),
        Menu(dayOfTheWeek: "Thursday", description: "Pizza"),
        Menu(dayOfTheWeek: "Friday", description: "Sushi"),
        Menu(dayOfTheWeek: "Saturday", description: nil),
        Menu(dayOfTheWeek: "Sunday", description: nil),
        Menu(dayOfTheWeek: "Monday", description: "Breakfast for lunch"),
        Menu(dayOfTheWeek: "Tuesday", description: "Hamburgers"),
        Menu(dayOfTheWeek: "Wednesday", description: "Spaghetti"),
        Menu(dayOfTheWeek: "Thursday", description: "Salmon"),
        Menu(dayOfTheWeek: "Friday", description: "Sandwiches"),
        Menu(dayOfTheWeek: "Saturday", description: nil)
    ]

    func getMenusFromAPI(page: Int, completion: @escaping (Result<Bool, Error>) -> ()) {
        api.getMenus(page: page) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let menus): print()
                self.menus.append(contentsOf: menus)
                completion(Result.success(true))
            case .failure(let error): completion(Result.failure(error))
            }
        }
    }
}


