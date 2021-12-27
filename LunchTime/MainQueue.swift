//
// Created by jarvis on 12/26/21.
//

import Foundation

protocol MainQueue {
    func async(execute: @escaping @convention(block) () -> Void)
}

class LunchMainQueue: MainQueue {
    func async(execute: @escaping @convention(block) () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
}