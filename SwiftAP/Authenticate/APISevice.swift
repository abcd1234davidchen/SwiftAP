import Foundation

class APIService {
    static let shared = APIService()
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpShouldSetCookies = true
        self.session = URLSession(configuration: configuration)
    }
    
    func login(credentials: Credentials,
               completion: @escaping (Result<Bool,Auth.AuthenticationError>) -> Void) {

        guard let selcrURL1 = URL(string:"https://selcrs.nsysu.edu.tw/menu4/Studcheck_sso2.asp") else{completion(.failure(.invalidCredentials)); return}
        var request = URLRequest(url: selcrURL1)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body:[String: String] = [
            "stuid": credentials.studentid,
            "SPassword": credentials.password
        ]
        let bodyString = body.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {completion(.failure(.networkError))}
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {completion(.failure(.invalidResponse))}
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {completion(.failure(.invalidResponse))}
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {completion(.failure(.invalidResponse))}
                return
            }
            
            if let htmlString = String(data: data, encoding: .utf8) {
                print("Server response HTML: \(htmlString)")
                if htmlString.contains("學號碼密碼不符") {
                    DispatchQueue.main.async {
                        print("Invalid credentials (HTML): \(htmlString)")
                        completion(.failure(.invalidCredentials))
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Login successful (HTML)")
                        completion(.success(true))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("Unable to decode response data to string")
                    completion(.failure(.invalidResponse))
                }
            }
        }.resume()
    }
}
