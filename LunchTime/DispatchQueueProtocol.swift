//
// Created by jarvis on 12/26/21.
//

import Foundation

protocol DispatchQueueProtocol {
    func async(execute: @escaping @convention(block) () -> Void)
}

class LunchDispatchQueue: DispatchQueueProtocol {
    func async(execute: @escaping @convention(block) () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
}