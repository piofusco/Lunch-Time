//
// Created by jarvis on 12/26/21.
//

import Foundation

@testable import LunchTime

class MockURLSessionDataTask: LunchURLSessionDataTask {
    var didResume = false
    var resumeNumberOfInvocations = 0

    func resume() {
        didResume = true
        resumeNumberOfInvocations += 1
    }
}