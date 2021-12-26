//
// Created by jarvis on 12/17/21.
//

import Foundation

protocol LunchURLSession {
    func makeDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> LunchURLSessionDataTask
}

extension URLSession: LunchURLSession {
    func makeDataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> LunchURLSessionDataTask {
        dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

public protocol LunchURLSessionDataTask {
    func resume()
}

extension URLSessionDataTask: LunchURLSessionDataTask {}