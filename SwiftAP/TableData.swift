//
//  TableData.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/28.
//
import SwiftUI
import Foundation

let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

let timeCode = [
    1: "07:00", 2: "08:00", 3: "09:00", 4: "10:00", 5: "11:00",
    6: "12:00", 7: "01:00", 8: "02:00", 9: "03:00", 10: "04:00",
    11: "05:00", 12: "06:00"
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
    let timeCode: String = timeToCode[hour] ?? "Off Class"
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
    return startTime + "~" + endTime
}

func dayInWeek() -> String? {
    let date: Date = Date()
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "e" // 使用 "E" 獲取縮寫，"EEEE" 獲取全名
    var day: String = dateFormatter.string(from: date)
    day=daysOfWeek[Int(day)!-2]
    return day
}

let coursesByDay: [String: [Course]] = [
    "Mon": [
        Course(name: "Math", additionalData: "Room 101",Time: "234"),
        Course(name: "Science", additionalData: "Lab 202",Time: "567")
    ],
    "Tue": [
        Course(name: "History", additionalData: "Room 303",Time: "234"),
        Course(name: "Art", additionalData: "Studio 404",Time: "567")
    ],
    "Wed": [
        Course(name: "Physics", additionalData: "Room 105",Time: "234"),
        Course(name: "Chemistry", additionalData: "Lab 205",Time: "567")
    ],
    "Thu": [
        Course(name: "English", additionalData: "Room 206",Time: "234"),
        Course(name: "C Language", additionalData: "Lab 306",Time: "567")
    ],
    "Fri": [
        Course(name: "Computer Science", additionalData: "Room 407",Time: "234"),
        Course(name: "Music", additionalData: "Auditorium",Time: "B"),
        Course(name: "Discrete Math", additionalData: "Class",Time: "567")
    ]
]

#Preview {TablePage()}
