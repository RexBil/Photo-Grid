
import Foundation
enum AppError: LocalizedError {
    case errorDecoding
    case unknowError
    case invalidUrl
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .errorDecoding:
            return "Response couldn't be decode"
        case .unknowError:
            return "Unknown Error"
        case .invalidUrl:
            return "Give valide Url"
        case .serverError(let error):
            return error
        }
    }
}
