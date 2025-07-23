import Foundation
import SwiftData

@MainActor
class ActivityViewModel: ObservableObject {
    @Published var error: Errors.CourseError?
    @Published var fetchYearSemester: String = ""
    @Published var courses: [DataItem] = []
    @Published var isLoading: Bool = false
    @Published var availableSemesters: [String] = []
    let maxRetry = 3
    
    var credentials = Credentials(
        studentid: KeychainHelper.shared.read(forKey: "studentid") ?? "",
        password: KeychainHelper.shared.read(forKey: "password") ?? ""
    )

    func setupWithContext(context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<AppInfo>()
        if let appInfo = try? context.fetch(fetchDescriptor).first {
            fetchYearSemester = appInfo.yearSemester
        } else {
            fetchYearSemester = "1132"
        }
        if let appInfo = try? context.fetch(fetchDescriptor).first {
            self.availableSemesters = appInfo.availableSemesters.components(separatedBy: ",").sorted(by: >)
        } else {
            self.availableSemesters = ["1131","1132"]
        }
    }

    func buildActivityPage(context: ModelContext, completion: @escaping (Bool) -> Void, retryCount: Int = 0){
        isLoading = true
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            print("Skip API call in Preview")
            let fakeCourses = [
                DataItem(code: "TEST001", name: "Test Course1", professor: "Test Professor", 
                        credit: "3", room: "Test Room", monday: "A1", tuesday: "34", wednesday: "B567", thursday: "A1",
                        friday: "234", saturday: "", sunday: "A", colorHex: colorHexList[0], englishName: "T1", grade:""),
                DataItem(code: "TEST002", name: "Test Course2", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "67", tuesday: "", wednesday: "", thursday: "4B5",
                        friday: "", saturday: "", sunday: "A", colorHex: colorHexList[1], englishName: "T1", grade:""),
                DataItem(code: "TEST003", name: "Test Course3", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "B", tuesday: "12", wednesday: "A12", thursday: "789",
                        friday: "", saturday: "", sunday: "67", colorHex: colorHexList[2], englishName: "T1", grade:""),
                DataItem(code: "TEST004", name: "Test Course4", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "23", tuesday: "", wednesday: "3", thursday: "",
                        friday: "567", saturday: "", sunday: "12", colorHex: colorHexList[3], englishName: "T1", grade:""),
                DataItem(code: "TEST005", name: "Test Course5", professor: "Test Professor",
                        credit: "3", room: "Test Room", monday: "9", tuesday: "", wednesday: "789", thursday: "",
                        friday: "", saturday: "678", sunday: "34", colorHex: colorHexList[4], englishName: "T1", grade:"")
            ]
            self.courses = fakeCourses
            self.isLoading = false
            completion(true)
            return
        }
        #endif
        Task{
            do{
                let fetchCourses = try await fetchCourse(context: context)
                for (index, course) in fetchCourses.enumerated() {
                    course.colorHex = course.colorHex.isEmpty ? colorHexList[index % colorHexList.count] : course.colorHex
                }
                DispatchQueue.main.async {
                    self.courses = fetchCourses
                    self.isLoading = false
                    completion(true)
                }
            }
            catch let error as Errors.CourseError {
                print("Error fetching courses: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = error
                }
                if error == .timeout, retryCount < maxRetry {
                    reloginAndFetch(context: context, completion: completion, retryCount: retryCount + 1)
                } else {
                    completion(false)
                }
            }
            catch {
                print("Error fetching courses: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                completion(false)
            }
        }
    }
    private func fetchCourse(context: ModelContext) async throws -> [DataItem] {
       return try await withCheckedThrowingContinuation{continuation in
            APIService.shared.course(credentials: credentials,yearSemester: fetchYearSemester){
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
                self.buildActivityPage(context: context, completion: completion, retryCount: retryCount)
            case .success(false), .failure:
                print("Relogin failed.")
                completion(false)
            }
        }
    }
}
