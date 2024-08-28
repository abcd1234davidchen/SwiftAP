//
//  TableData.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/28.
//
import SwiftUI

let daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

let coursesByDay: [String: [Course]] = [
        "Mon": [
            Course(name: "Math", additionalData: "Room 101"),
            Course(name: "Science", additionalData: "Lab 202")
        ],
        "Tue": [
            Course(name: "History", additionalData: "Room 303"),
            Course(name: "Art", additionalData: "Studio 404")
        ],
        "Wed": [
            Course(name: "Physics", additionalData: "Room 105"),
            Course(name: "Chemistry", additionalData: "Lab 205")
        ],
        "Thu": [
            Course(name: "English", additionalData: "Room 206"),
            Course(name: "C Language", additionalData: "Lab 306")
        ],
        "Fri": [
            Course(name: "Computer Science", additionalData: "Room 407"),
            Course(name: "Music", additionalData: "Auditorium"),
            Course(name: "Discrete Math", additionalData: "Class")
       ]
//        ,
//        "Sat": [
//            Course(name: "Computer Science", additionalData: "Room 407"),
//            Course(name: "Music", additionalData: "Auditorium"),
//        ]
]

#Preview {
    TablePage()
}
