import SwiftUI

class Errors: ObservableObject {
    enum CourseError: Error, LocalizedError, Identifiable {
        case timeout
        case networkError
        case invalidResponse

        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .timeout:
                return NSLocalizedString("Request timed out", comment: "")
            case .networkError:
                return NSLocalizedString("Network Error", comment: "")
            case .invalidResponse:
                return NSLocalizedString("Invalid response from server", comment: "")
            }
        }
    }
}
