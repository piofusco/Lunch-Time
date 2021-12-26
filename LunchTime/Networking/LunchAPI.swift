//
// Created by jarvis on 12/26/21.
//

import Foundation

protocol LunchAPI {
    func getMenus(page: Int, completion: @escaping (Result<[DailyMenu], Error>) -> Void)
}

class GustoLunchAPI : LunchAPI {
    private let urlSession: LunchURLSession
    private let baseURLString = "http://localhost:4567/api/menu/"

    init(urlSession: LunchURLSession) {
        self.urlSession = urlSession
    }

    func getMenus(page: Int, completion: @escaping (Result<[DailyMenu], Error>) -> ()) {
        guard let url = URL(string: baseURLString + "?page=\(page)") else { return }

        urlSession.makeDataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error { completion(Result.failure(error)) }

            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }

                var response: [DailyMenu]?
                do {
                    response = try JSONDecoder().decode([DailyMenu].self, from: data)
                } catch {
                    print(error)
                }

                if let responseToReturn = response { completion(Result.success(responseToReturn)) }
            } else if response.statusCode == 400 {
                completion(Result.failure(LunchError.badRequest))
            } else if response.statusCode == 500 {
                completion(Result.failure(LunchError.internalServerError))
            }
        }.resume()
    }
}