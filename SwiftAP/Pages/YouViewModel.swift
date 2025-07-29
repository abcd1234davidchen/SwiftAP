import Foundation
import SwiftData

@MainActor
class YouViewModel: ObservableObject {
    @Published var error: Errors.CourseError?
    let maxRetry = 3
    
    var credentials = Credentials(
        studentid: KeychainHelper.shared.read(forKey: "studentid") ?? "",
        password: KeychainHelper.shared.read(forKey: "password") ?? ""
    )

    func buildYouPage(context: ModelContext, completion: @escaping (Bool) -> Void, retryCount: Int = 0){
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            print("Skip API call in Preview")
            let fakeCourses = [
                DataItem(code: "TEST001", name: "Test Course 1", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "A1", tuesday: "34", wednesday: "B567", thursday: "A1",
                        friday: "234", saturday: "", sunday: "A", colorHex: colorHexList[0], englishName: "T1", grade:""),
                DataItem(code: "TEST002", name: "Test Course 2", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "67", tuesday: "", wednesday: "", thursday: "4B5",
                        friday: "", saturday: "", sunday: "A", colorHex: colorHexList[1], englishName: "T1", grade:""),
                DataItem(code: "TEST003", name: "Test Course 3", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "B", tuesday: "12", wednesday: "A12", thursday: "789",
                        friday: "", saturday: "", sunday: "67", colorHex: colorHexList[2], englishName: "T1", grade:""),
                DataItem(code: "TEST004", name: "Test Course 4", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "23", tuesday: "", wednesday: "3", thursday: "",
                        friday: "567", saturday: "", sunday: "12", colorHex: colorHexList[3], englishName: "T1", grade:""),
                DataItem(code: "TEST005", name: "Test Course 5", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "9", tuesday: "", wednesday: "89", thursday: "",
                        friday: "", saturday: "678", sunday: "34", colorHex: colorHexList[4], englishName: "T1", grade:"")
            ]
            let fetchDescriptor = FetchDescriptor<DataItem>()
            let existingCourses = try? context.fetch(fetchDescriptor)
            let existingDict = Dictionary(uniqueKeysWithValues: (existingCourses ?? []).map { ($0.code, $0) })
            let fetchedDict = Dictionary(uniqueKeysWithValues: fakeCourses.map { ($0.code, $0) })

            for course in fakeCourses {
                if let existing = existingDict[course.code] {
                    existing.name = course.name
                    existing.professor = course.professor
                    existing.credit = course.credit
                    existing.room = course.room
                    existing.monday = course.monday
                    existing.tuesday = course.tuesday
                    existing.wednesday = course.wednesday
                    existing.thursday = course.thursday
                    existing.friday = course.friday
                    existing.saturday = course.saturday
                    existing.sunday = course.sunday
                } else {
                    context.insert(course)
                }
            }
            for existing in existingCourses ?? [] {
                if fetchedDict[existing.code] == nil {
                    context.delete(existing)
                }
            }
            try? context.save()
            completion(true)
            return
        }
        #endif
        Task{
            do{
                let fetchCourses = try await fetchCourse(context: context)
                let fetchDescriptor = FetchDescriptor<DataItem>()
                let existingCourses = try context.fetch(fetchDescriptor)

                let existingDict = Dictionary(uniqueKeysWithValues: existingCourses.map { ($0.code, $0) })
                let fetchedDict = Dictionary(uniqueKeysWithValues: fetchCourses.map { ($0.code, $0) })

                for (index, course) in fetchCourses.enumerated() {
                    if let existing = existingDict[course.code] {
                        existing.name = course.name
                        existing.professor = course.professor
                        existing.credit = course.credit
                        existing.room = course.room
                        existing.monday = course.monday
                        existing.tuesday = course.tuesday
                        existing.wednesday = course.wednesday
                        existing.thursday = course.thursday
                        existing.friday = course.friday
                        existing.saturday = course.saturday
                        existing.sunday = course.sunday
                        existing.englishName = course.englishName
                        existing.grade = course.grade
                    } else {
                        course.colorHex = course.colorHex.isEmpty ? colorHexList[index % colorHexList.count] : course.colorHex
                        context.insert(course)
                    }
                }
                for existing in existingCourses {
                    if fetchedDict[existing.code] == nil {
                        context.delete(existing)
                    }
                }
                try context.save()
                DispatchQueue.main.async {
                    completion(true)
                }
            }
            catch let error as Errors.CourseError {
                print("Error fetching courses: \(error)")
                if error == .timeout, retryCount < maxRetry {
                    reloginAndFetch(context: context, completion: completion, retryCount: retryCount + 1)
                } else {
                    completion(false)
                }
            }
            catch {
                print("Error fetching courses: \(error)")
                completion(false)
            }
        }
    }
    private func fetchCourse(context: ModelContext) async throws -> [DataItem] {
        var yearSemesterValue = ""
        let fetchDescriptor = FetchDescriptor<AppInfo>()
        if let appInfo = try context.fetch(fetchDescriptor).first {
            yearSemesterValue = appInfo.yearSemester
        }
        return try await withCheckedThrowingContinuation{continuation in
            APIService.shared.course(credentials: credentials,yearSemester: yearSemesterValue){
                result in switch result{
                case .success(let courses):
                    continuation.resume(returning: courses)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func reloginAndFetch(context: ModelContext, completion: @escaping (Bool) -> Void, retryCount: Int) {
        print("Relogin attempt #\(retryCount)...")
        APIService.shared.login(credentials: self.credentials) { result in
            switch result {
            case .success(true):
                print("Relogin successful, retrying to fetch courses...")
                // Rery the original request
                self.buildYouPage(context: context, completion: completion, retryCount: retryCount)
            case .success(false), .failure:
                print("Relogin failed.")
                completion(false)
            }
        }
    }
}
