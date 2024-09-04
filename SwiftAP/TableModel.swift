//
//  TableData.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/28.
//
import SwiftUI
import Foundation

let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

let timeCode = [
    1: "07:00", 2: "08:00", 3: "09:00", 4: "10:00", 5: "11:00",
    6: "12:00", 7: "13:00", 8: "14:00", 9: "15:00", 10: "16:00",
    11: "17:00", 12: "18:00"
]

let codeMapping: [Character: Int] = [
    "A": 1, "1": 2, "2": 3, "3": 4, "4": 5,
    "B": 6, "5": 7, "6": 8, "7": 9, "8": 10,
    "9": 11
]

func getCurrentTimeCode() -> String? {
    
    let timeToCode: [Int: String] = [
        7: "A", 8: "1", 9: "2", 10: "3",
        11: "4", 12: "B", 13: "5", 14: "6",
        15: "7", 16: "8", 17: "9"
    ]

    let date: Date = Date()
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH"
    let hour: Int = Int(dateFormatter.string(from: date))!
    let timeCode: String = timeToCode[hour] ?? "no such"
    return timeCode
}

func convertedTime(code: String) -> String? {
    guard let firstChar = code.first,
          let index = codeMapping[firstChar],
          let startTime = timeCode[index] else {
        return nil
    }
    guard let secondChar = code.last,
          let secondIndex = codeMapping[secondChar].map({ $0 + 1 }),
          let endTime = timeCode[secondIndex] else {
        return nil
    }
    return startTime + " - " + endTime
}

func dayInWeek() -> String? {
    let date: Date = Date()
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "e" // 使用 "E" 獲取縮寫，"EEEE" 獲取全名
    let day: String = dateFormatter.string(from: date)
    return daysOfWeek[Int(day)!-1]
}

func removeEnglishSuffix(from input: String) -> String {
    // Regular expression pattern to match any English characters and spaces at the end of the string
    let pattern = "[a-zA-Z :&/（,：＆]+$"
    
    var modifiedString = input.dropLast(1)
    
    // Loop to keep removing the English suffix until there's no more match
    while let range = modifiedString.range(of: pattern, options: .regularExpression) {
        modifiedString.removeSubrange(range)
    }
    
    return String(modifiedString)
}
#Preview {
    ContentView()
}
