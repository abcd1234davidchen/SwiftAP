import SwiftUI

class Auth: ObservableObject {
    @Published var isValidated: Bool = false
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
            case invalidCredentials
            
            var id: String {
                self.localizedDescription
            }
            
            var errorDescription: String? {
                switch self {
                case .invalidCredentials:
                    return NSLocalizedString("Student ID or password are incorrect", comment: "")
                }
            }
        }
    
    func updateValidation(success: Bool){
        withAnimation {
            isValidated = success
        }
    }
}
