//
// Created by jarvis on 12/27/21.
//

import Foundation
@testable import LunchTime

class MockJSONDecoder<T: Decodable>: LunchDecoder {
    var nextDecodable: T?

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        guard let nextDecodable = nextDecodable as? T else {
            fatalError("Next decodable not set")
        }

        return nextDecodable
    }
}