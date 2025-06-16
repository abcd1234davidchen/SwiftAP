import Foundation

class LoginViewModel: ObservableObject {
    @Published var credentials = Credentials()
    @Published var showProgressVIew = false
    @Published var error: Auth.AuthenticationError?
    
    var loginDisabled: Bool{
        credentials.studentid.isEmpty || credentials.password.isEmpty
    }
    
    func login(completion: @escaping(Bool)->Void){
        showProgressVIew = true
        APIService.shared.login(credentials: credentials) { [unowned self](result:Result<Bool,Auth.AuthenticationError>) in
            showProgressVIew = false
            switch result{
            case .success:
                KeychainHelper.shared.save(self.credentials.studentid, forKey: "studentid")
                KeychainHelper.shared.save(self.credentials.password, forKey: "password")
                self.credentials = Credentials(studentid: KeychainHelper.shared.read(forKey: "studentid") ?? "",
                                               password: KeychainHelper.shared.read(forKey: "password") ?? "")
                completion(true)
            case .failure(let authError):
                credentials = Credentials()
                error = authError
                completion(false)
            }
        }
    }
}
