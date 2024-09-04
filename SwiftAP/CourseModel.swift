//
//  CourseModel.swift
//  SwiftAP
//
//  Created by David Chen on 2024/9/5.
//

import Foundation
import SwiftSoup
import Combine

class SharedData: ObservableObject {
    @Published var coursesByDay: [String: [Course]] = [:]
}

class CourseViewModel: ObservableObject {

    func getCourseDate(username: String, sharedData: SharedData) {
        Task {
            do {
                // Base settings for HTML POST
                let parameters = [
                    "stuact": "B",
                    "YRSM": "1131",
                    "Stuid": username,
                    "B1": "%BDT%A9w%B0e%A5X"
                ]
                let postData = parameters.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)
                
                guard let url = URL(string: "https://selcrs.nsysu.edu.tw/menu4/query/stu_slt_data.asp") else {
                    print("Invalid URL")
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpBody = postData
                
                let (data, _) = try await URLSession.shared.data(for: request)
                let html = String(data: data, encoding: .utf8) ?? ""
                
                let doc = try SwiftSoup.parse(html)
                
                // Get user name
                if let nameElement = try doc.select("div").first(),
                   let nameText = try? nameElement.text(trimAndNormaliseWhitespace: true) {
                    let nameWords = nameText.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
                    let initials = Array(nameWords.prefix(3))
                    print("Data:", initials)
                } else {
                    print("Name not found")
                }
                
                // Directly modify coursesByDay
                sharedData.coursesByDay = [:]
                let rows = try doc.getElementsByTag("tr")
                
                for (index, row) in rows.enumerated() {
                    if index == 0 { continue }
                    
                    var cellText: [String] = []
                    let cells = try row.getElementsByTag("td")
                    
                    for cell in cells {
                        let text = try cell.text(trimAndNormaliseWhitespace: true)
                        cellText.append(text)
                    }
                    
                    for i in 1...7 {
                        let day = daysOfWeek[i % 7]
                        let dayInt = 9 + i
                        
                        if cellText[dayInt] != " " {
                            var additionalData = cellText[9]
                            if let pruned = additionalData.firstIndex(of: "(") {
                                additionalData = String(additionalData.suffix(from: pruned))
                                additionalData.removeFirst()
                                additionalData.removeLast()
                                additionalData = removeEnglishSuffix(from: additionalData)
                            }
                            
                            let course = Course(name: removeEnglishSuffix(from: cellText[4]), additionalData: additionalData, Time: cellText[dayInt])
                            if sharedData.coursesByDay[day] != nil {
                                sharedData.coursesByDay[day]?.append(course)
                            } else {
                                sharedData.coursesByDay[day] = [course]
                            }
                        }
                    }
                }
                
                // Sort courses by time
                for day in daysOfWeek {
                    if var courses = sharedData.coursesByDay[day] {
                        courses.sort { course1, course2 in
                            let time1 = codeMapping[course1.Time.first!] ?? 0
                            let time2 = codeMapping[course2.Time.first!] ?? 0
                            return time1 < time2
                        }
                        sharedData.coursesByDay[day] = courses
                    }
                }
                
            } catch {
                print("Failed to fetch or parse data: \(error.localizedDescription)")
            }
        }
    }
}

