import Foundation
import SwiftData

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
    init(code: String, name: String, professor: String, credit: String, room: String,
         monday: String, tuesday: String, wednesday: String, thursday: String,
         friday: String, saturday: String, sunday: String, colorHex: String, englishName: String) {
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
    }
}

@Model
class AppInfo: Identifiable {
    var id: String
    var yearSemester: String
    var userName: String
    init(id: String, yearSemester: String, userName: String) {
        self.id = id
        self.yearSemester = yearSemester
        self.userName = userName
    }
}
