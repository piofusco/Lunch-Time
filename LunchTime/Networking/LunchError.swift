//
// Created by jarvis on 12/17/21.
//

import Foundation

enum LunchError: Error {
    case badRequest
    case invalidJSON
    case invalidURL
    case internalServerError
    case noDataReturned
    case unexpected(code: Int)
}

extension LunchError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .badRequest: return "Bad Request."
        case .invalidJSON: return "Unable to parse JSON."
        case .invalidURL: return "Invalid URL."
        case .internalServerError: return "Internal Server Error."
        case .noDataReturned: return "No data returned."
        case .unexpected(_): return "An unexpected error occurred."
        }
    }
}

extension LunchError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest: return NSLocalizedString(
                "Description of bad request",
                comment: "Bad Request."
        )
        case .invalidJSON: return NSLocalizedString(
                "Description of invalid JSON",
                comment: "Unable to parse JSON."
        )
        case .invalidURL: return NSLocalizedString(
                "Description of invalid URL",
                comment: "Invalid URL."
        )
        case .internalServerError: return NSLocalizedString(
                "Description of internal server error",
                comment: "Internal Server Error."
        )
        case .noDataReturned: return NSLocalizedString(
                "Description of no data returned",
                comment: "Request did not return expected data."
        )
        case .unexpected(_): return NSLocalizedString(
                "Description of unexpected",
                comment: "An unexpected error occurred."
        )
        }
    }
}