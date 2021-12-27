//
// Created by jarvis on 12/26/21.
//

import Foundation

protocol LunchAPI {
    func getMenus(completion: @escaping (Result<[Menu], Error>) -> ())
}

class GustoLunchAPI: LunchAPI {
    private let baseURLString = "http://localhost:4567/api/menu"

    private let urlSession: LunchURLSession
    private let decoder: LunchDecoder

    init(urlSession: LunchURLSession, decoder: LunchDecoder) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func getMenus(completion: @escaping (Result<[Menu], Error>) -> ()) {
        guard let url = URL(string: baseURLString) else {
            completion(Result.failure(LunchError.invalidURL))
            return
        }

        urlSession.makeDataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            if let error = error { completion(Result.failure(error)) }

            guard let response = response as? HTTPURLResponse else {
                completion(Result.failure(LunchError.unexpected(code: -1)))
                return
            }

            switch response.statusCode {
            case 200..<299:
                guard let decoder = self?.decoder else {
                    completion(Result.failure(LunchError.unexpected(code: -1)))
                    return
                }

                guard let data = data else {
                    completion(Result.failure(LunchError.noDataReturned))
                    return
                }

                var response: [Menu]?
                do {
                    response = try decoder.decode([Menu].self, from: data)
                } catch {
                    completion(Result.failure(LunchError.invalidJSON))
                }

                guard let responseToReturn = response else {
                    completion(Result.failure(LunchError.unexpected(code: -1)))
                    return
                }

                completion(Result.success(responseToReturn))
            case 400..<499: completion(Result.failure(LunchError.badRequest))
            case 500..<599: completion(Result.failure(LunchError.internalServerError))
            default: completion(Result.failure(LunchError.unexpected(code: -1)))
            }
        }.resume()
    }
}