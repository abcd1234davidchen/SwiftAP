import Foundation
import SwiftData

@MainActor
class YouViewModel: ObservableObject {
    @Published var error: Errors.CourseError?
    
    var credentials = Credentials(
        studentid: KeychainHelper.shared.read(forKey: "studentid") ?? "",
        password: KeychainHelper.shared.read(forKey: "password") ?? ""
    )

    func buildYouPage(context: ModelContext, completion: @escaping (Bool) -> Void){
        Task{
            do{
                let fetchCourses = try await fetchCourse(context: context)
                let fetchDescriptor = FetchDescriptor<DataItem>()
                let existingCourses = try context.fetch(fetchDescriptor)

                let existingDict = Dictionary(uniqueKeysWithValues: existingCourses.map { ($0.code, $0) })
                let fetchedDict = Dictionary(uniqueKeysWithValues: fetchCourses.map { ($0.code, $0) })

                for course in fetchCourses {
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
}
