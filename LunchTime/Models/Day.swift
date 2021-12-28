//
// Created by jarvis on 12/27/21.
//

import Foundation

struct Day {
    let date: Date
    let number: String
    let menu: Menu?
}

enum Menu: Int, CaseIterable {
    case chickenAndWaffles = 0
    case tacos
    case curry
    case pizza
    case sushi
    case breakfast
    case hamburgers
    case spaghetti
    case salmon
    case sandwiches

    func toString() -> String {
        switch self {
        case .chickenAndWaffles: return "Chicken and waffles"
        case .tacos: return "Tacos"
        case .curry: return "Curry"
        case .pizza: return "Pizza"
        case .sushi: return "Sushi"
        case .breakfast: return "Breakfast for lunch"
        case .hamburgers: return "Hamburgers"
        case .spaghetti: return "Spaghetti"
        case .salmon: return "Salmon"
        case .sandwiches: return "Sandwiches"
        }
    }
}