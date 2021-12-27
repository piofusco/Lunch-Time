//
// Created by jarvis on 12/17/21.
//

import XCTest

@testable import LunchTime

class APITest: XCTestCase {
    func test__getMenus__callResume__ensureURL() {
        let mockURLSession = MockURLSession()
        let mockURLSessionDataTask = MockURLSessionDataTask()
        mockURLSession.nextDataTask = mockURLSessionDataTask
        let subject = GustoLunchAPI(urlSession: mockURLSession)

        subject.getMenus { _ in }

        XCTAssertTrue(mockURLSessionDataTask.didResume)
        XCTAssertEqual(mockURLSession.lastURL, URL(string: "http://localhost:4567/api/menu"))
    }

    func test__getMenus__200__callCompletionWithData() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextResponses = [HTTPURLResponse.Happy200Request]
        mockURLSession.nextData = pageResponseJSON
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = GustoLunchAPI(urlSession: mockURLSession)
        var completionDidRun = false
        var returnedDailyMenus: [Menu]?

        subject.getMenus { result in
            completionDidRun = true

            switch result {
            case .success(let pageResponse): returnedDailyMenus = pageResponse
            case .failure(_): XCTFail("result shouldn't be a failure")
            }
        }

        XCTAssertTrue(completionDidRun)
        guard let menus = returnedDailyMenus else {
            XCTFail("Failed to unwrap returned menus")
            return
        }
        XCTAssertEqual(menus.count, 2)
        XCTAssertEqual(menus[0].dayOfTheWeek, "Sunday")
        XCTAssertNil(menus[0].description)
        XCTAssertEqual(menus[1].dayOfTheWeek, "Monday")
        XCTAssertEqual(menus[1].description, "some menu 1")
    }

    func test__getMenus__200__noData__doNotRunCompletion() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextResponses = [HTTPURLResponse.Happy200Request]
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = GustoLunchAPI(urlSession: mockURLSession)
        var completionDidRun = false

        subject.getMenus { result in
            completionDidRun = true
            XCTFail("should not run completion")
        }

        XCTAssertFalse(completionDidRun)
    }

    func test__getMenus__400__callCompletionWithFailure() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextResponses = [HTTPURLResponse.BadRequestError]
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = GustoLunchAPI(urlSession: mockURLSession)
        var completionDidRun = false

        subject.getMenus { result in
            switch result {
            case .success(_): XCTFail("result shouldn't be a failure")
            case .failure(let error):
                completionDidRun = true
                XCTAssertTrue(error is LunchError)
            }
        }

        XCTAssertTrue(completionDidRun)
    }

    func test__getMenus__500__callCompletionWithFailure() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextResponses = [HTTPURLResponse.InternalServerError]
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = GustoLunchAPI(urlSession: mockURLSession)
        var completionDidRun = false

        subject.getMenus { result in
            switch result {
            case .success(_): XCTFail("result shouldn't be a failure")
            case .failure(let error):
                completionDidRun = true
                XCTAssertTrue(error is LunchError)
            }
        }

        XCTAssertTrue(completionDidRun)
    }

    func test__getMenus__error__callCompletionWithError() {
        let mockURLSession = MockURLSession()
        mockURLSession.nextError = NSError(domain: "doesn't matter", code: 666)
        mockURLSession.nextDataTask = MockURLSessionDataTask()
        let subject = GustoLunchAPI(urlSession: mockURLSession)
        var completionDidRun = false

        subject.getMenus { result in
            switch result {
            case .success(_): XCTFail("result shouldn't be a failure")
            case .failure(_): completionDidRun = true
            }
        }

        XCTAssertTrue(completionDidRun)
    }
}

fileprivate extension HTTPURLResponse {
    static var Happy200Request = HTTPURLResponse(url: URL(string: "https://does.not.matter")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static var BadRequestError = HTTPURLResponse(url: URL(string: "https://does.not.matter")!, statusCode: 400, httpVersion: nil, headerFields: nil)!
    static var InternalServerError = HTTPURLResponse(url: URL(string: "https://does.not.matter")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
}

fileprivate let pageResponseJSON = """
[
    {
      "dayOfTheWeek": "Sunday"
    },
    {
      "dayOfTheWeek": "Monday",
      "description": "some menu 1"
    }
]
""".data(using: .utf8)