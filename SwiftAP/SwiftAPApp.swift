import SwiftUI
import Network

@main
struct SwiftAPApp: App {
    @StateObject var auth = Auth()
    @StateObject var loginVM = LoginViewModel()
    @State private var triedAutoLogin = false

    var body: some Scene {
        WindowGroup {
            if auth.isValidated {
                MainTabView()
                    .environmentObject(auth)
            }
            else if !triedAutoLogin {
                Color.clear.onAppear {
                    let monitor = NWPathMonitor()
                    monitor.pathUpdateHandler = { path in
                        if path.status == .satisfied {
                            let studentid = KeychainHelper.shared.read(forKey: "studentid") ?? ""
                            let password = KeychainHelper.shared.read(forKey: "password") ?? ""
                            if !studentid.isEmpty && !password.isEmpty {
                                DispatchQueue.main.async {
                                    loginVM.credentials = Credentials(studentid: studentid, password: password)
                                    loginVM.login { success in
                                        auth.updateValidation(success: success)
                                        triedAutoLogin = true
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    triedAutoLogin = true
                                }
                            }
                        } else {
                            triedAutoLogin = true
                        }
                    }
                    let queue = DispatchQueue(label: "NetworkMonitor")
                    monitor.start(queue: queue)
                }
            }
            else {
                LoginView()
                    .environmentObject(auth)
            }
        }
    }
}
