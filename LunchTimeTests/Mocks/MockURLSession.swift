//
// Created by jarvis on 12/17/21.
//

import Foundation

@testable import LunchTime

class MockURLSession: LunchURLSession {
    var lastURL: URL?

    var nextData: Data?
    var nextResponses: [HTTPURLResponse] = []
    var nextError: Error?

    var nextDataTask: LunchURLSessionDataTask?

    func makeDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> LunchURLSessionDataTask {
        lastURL = request.url

        var nextResponse: HTTPURLResponse?
        if nextResponses.count > 0 {
            nextResponse = nextResponses.removeFirst()
        }

        completionHandler(nextData, nextResponse, nextError)

        guard let nextDataTask = nextDataTask else { fatalError("next data task not set") }
        return nextDataTask
    }
}