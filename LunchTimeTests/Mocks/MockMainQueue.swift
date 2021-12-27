//
// Created by jarvis on 12/26/21.
//

@testable import LunchTime

class MockMainQueue: MainQueue {
    var didAsync = false

    func async(execute: @escaping @convention(block) () -> ()) {
        didAsync = true

        execute()
    }
}