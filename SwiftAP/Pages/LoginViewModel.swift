import Foundation
import CryptoKit

@MainActor
class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var showProgressVIew = false
    @Published var error: Auth.AuthenticationError?
    
    var loginDisabled: Bool {
        credentials.studentid.isEmpty || credentials.password.isEmpty
    }
    
    func login(completion: @escaping(Bool) -> Void) {
        showProgressVIew = true
        error = nil
        let passwordData = credentials.password.data(using: .utf8) ?? Data()
        let md5 = Insecure.MD5.hash(data: passwordData)
        let md5Data = Data(md5)
        let base64md5 = md5Data.base64EncodedString()
        credentials.password = base64md5
        print("MD5 Encoded Password: \(base64md5)")
        
        Task {
            do {
                let success = try await performLogin()
                showProgressVIew = false
                
                if success {
                    KeychainHelper.shared.save(credentials.studentid, forKey: "studentid")
                    KeychainHelper.shared.save(credentials.password, forKey: "password")
                    credentials = Credentials(
                        studentid: KeychainHelper.shared.read(forKey: "studentid") ?? "",
                        password: KeychainHelper.shared.read(forKey: "password") ?? ""
                    )
                    completion(true)
                } else {
                    credentials = Credentials()
                    completion(false)
                }
                
            } catch let authError as Auth.AuthenticationError {
                showProgressVIew = false
                credentials = Credentials()
                error = authError
                completion(false)
            } catch {
                showProgressVIew = false
                credentials = Credentials()
                self.error = .networkError
                completion(false)
            }
        }
    }
    
    private func performLogin() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            APIService.shared.login(credentials: credentials) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
