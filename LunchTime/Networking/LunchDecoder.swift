//
// Created by jarvis on 12/27/21.
//

import Foundation

protocol LunchDecoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: LunchDecoder {}