import Foundation
import CryptoKit
import SwiftSoup

class APIService {
    static let shared = APIService()
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.httpShouldSetCookies = true
        self.session = URLSession(configuration: configuration)
    }
    
    func login(credentials: Credentials, completion:
               @escaping (Result<Bool,Auth.AuthenticationError>) -> Void) {

        let passwordData = credentials.password.data(using: .utf8) ?? Data()
        let md5 = Insecure.MD5.hash(data: passwordData)
        let md5Data = Data(md5)
        let base64md5 = md5Data.base64EncodedString()
        
        guard let url = URL(string:"https://selcrs.nsysu.edu.tw/menu4/Studcheck_sso2.asp")
        else{completion(.failure(.invalidResponse)); return}
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body:[String: String] = [
            "stuid": credentials.studentid,
            "SPassword": base64md5
        ]
        let bodyString = body.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {completion(.failure(.networkError))}
                return
            }
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data
            else {
                DispatchQueue.main.async {completion(.failure(.invalidResponse))}
                return
            }
            
            if let htmlString = String(data: data, encoding: .utf8) {
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
    func course(credentials: Credentials, yearSemester: String = "", completion:
                @escaping (Result<[DataItem],Errors.CourseError>) -> Void) {

        guard let url = URL(string:"https://selcrs.nsysu.edu.tw/menu4/query/stu_slt_data.asp")
        else {completion(.failure(.invalidResponse)); return}
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let body:[String: String] = [
            "stuact": "B",
            "YRSM": yearSemester,
            "Stuid": credentials.studentid,
            "B1": "%BDT%A9w%B0e%A5X",
        ]
        let bodyString = body.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = bodyString.data(using: .utf8)

        session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {completion(.failure(.networkError))}
                return
            }
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data
            else {
                DispatchQueue.main.async {completion(.failure(.invalidResponse))}
                return
            }
            
            if let htmlString = String(data: data, encoding: .utf8) {
                do{
                    if htmlString.contains("請重新登入") {
                        DispatchQueue.main.async {
                            completion(.failure(.timeout))
                        }
                    } else {
                        let doc = try SwiftSoup.parse(htmlString)
                        var courses: [DataItem] = []
                        let rows = try doc.getElementsByTag("tr")

                        for (index,row) in rows.enumerated() {
                            if index == 0 { continue }
                            let cells = try row.getElementsByTag("td")
                            let course = DataItem(code: try cells[2].text(), name: try cells[4].text(),professor: try cells[8].text(),credit: try cells[5].text(), room: try cells[9].text(), monday: try cells[10].text(), tuesday: try cells[11].text(), wednesday: try cells[12].text(), thursday: try cells[12].text(), friday: try cells[13].text(), saturday: try cells[14].text(), sunday: try cells[15].text())
                            courses.append(course)
                        }

                        DispatchQueue.main.async {
                            print("Login successful (HTML)")
                            completion(.success(courses))
                        }
                    }
                }catch {
                    print("Error parsing HTML: \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(.invalidResponse))
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
