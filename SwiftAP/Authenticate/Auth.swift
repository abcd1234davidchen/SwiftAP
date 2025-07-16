import SwiftUI

@MainActor
class Auth: ObservableObject {
    @Published var isValidated: Bool = false
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
            case invalidCredentials
            case networkError
            case invalidResponse

            var id: String {
                self.localizedDescription
            }
            
            var errorDescription: String? {
                switch self {
                case .invalidCredentials:
                    return NSLocalizedString("Invalid credentials", comment: "")
                case .networkError:
                    return NSLocalizedString("Network Error", comment: "")
                case .invalidResponse:
                    return NSLocalizedString("Invalid response from server", comment: "")
                }
            }
        }
    
    func updateValidation(success: Bool) {
            if Thread.isMainThread {
                withAnimation {
                    self.isValidated = success
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    withAnimation {
                        self.isValidated = success
                    }
                }
            }
        }
}
