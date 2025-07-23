import Foundation
import SwiftData
import SwiftUI

@Model
class DataItem: Identifiable {
    var id: String = UUID().uuidString
    var code: String
    var name: String
    var professor: String
    var credit: String
    var room: String
    var monday: String
    var tuesday: String
    var wednesday: String
    var thursday: String
    var friday: String
    var saturday: String
    var sunday: String
    var colorHex: String
    var englishName: String
    var grade: String
    init(code: String, name: String, professor: String, credit: String, room: String,
         monday: String, tuesday: String, wednesday: String, thursday: String,
         friday: String, saturday: String, sunday: String, colorHex: String, englishName: String, grade: String) {
        self.code = code
        self.name = name
        self.room = room
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
        self.professor = professor
        self.credit = credit
        self.colorHex = colorHex
        self.englishName = englishName
        self.grade = grade
    }
}

@Model
class AppInfo: Identifiable {
    var id: String
    var yearSemester: String
    var availableSemesters: String
    var userName: String
    init(id: String, yearSemester: String, userName: String, availableSemesters: String) {
        self.id = id
        self.yearSemester = yearSemester
        self.userName = userName
        self.availableSemesters = availableSemesters
    }
}

let colorHexList: [String] = [
    //https://coolors.co/ff8585-ffc885-fed85d-92dd95-8cc9ca-85b4ff-a899ff-ffadff
    "#ff8585","#ffc885","#FED85D","#92DD95","#8CC9CA","#85b4ff","#a899ff","#ffadff",
    "#ff5c5c","#ffb65c","#FECF34","#73D377","#73BDBF","#5c9aff","#8670ff","#ff85ff",
    "#ff3333","#ffa333","#FEC50B","#54C958","#57AFB2","#3381ff","#6347ff","#ff5cff"
]

func hexStringToColor(hex: String, opacity: Double = 1.0) -> Color {
    var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if cString.hasPrefix("#") {
        cString.remove(at: cString.startIndex)
    }
    if cString.count != 6 {
        return Color.gray.opacity(opacity)
    }
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
    let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
    let b = Double(rgbValue & 0x0000FF) / 255.0
    return Color(red: r, green: g, blue: b).opacity(opacity)
}
