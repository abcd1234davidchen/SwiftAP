import SwiftUI
import SwiftData

struct YouView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var youVM = YouViewModel()
    @Query var courses: [DataItem]

    var todayCourses: [DataItem] {
        courses.filter { course in
            let weekday = Calendar.current.component(.weekday, from: Date())
            var str = ""
            switch weekday {
                case 1: str = course.sunday
                case 2: str = course.monday
                case 3: str = course.tuesday
                case 4: str = course.wednesday
                case 5: str = course.thursday
                case 6: str = course.friday
                case 7: str = course.saturday
                default: str = ""
            }
            return !str.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }

    var upcomingCourses: [DataItem] {
        todayCourses.filter { course in
            let time = Calendar.current.component(.hour, from: Date())
            let timePeriod: [String: Int] = [
                "A": 7, "1": 8, "2": 9, "3": 10, "4": 11,
                "B": 12, "5": 13, "6": 14, "7": 15, "8": 16, "9": 17,"C": 23
            ]
            let weekday = Calendar.current.component(.weekday, from: Date())
            var str = ""
            switch weekday {
                case 1: str = course.sunday
                case 2: str = course.monday
                case 3: str = course.tuesday
                case 4: str = course.wednesday
                case 5: str = course.thursday
                case 6: str = course.friday
                case 7: str = course.saturday
                default: str = ""
            }
            print("string: \(str)")
            for (key, hour) in timePeriod {
                if hour >= time && str.contains(key) {
                    return true
                }
            }
            return false
        }
        //TODO: Sort them by time
    }

    var body: some View {
        NavigationStack(){
            ZStack(content: {
                ScrollView {
                    VStack{
                        ForEach(upcomingCourses){course in
                            courseDesign(courseName: course.name, classroom: course.room, period: course.sunday, professor: course.professor)
                        }
                    }.frame(maxHeight: .infinity, alignment: .top)
                }
            })
            .navigationTitle("Good Day")
            .onAppear{
                youVM.buildYouPage(context: context) { success in
                    print("Fetched courses successfully: \(success)")
                }
            }
        }
    }
}

struct courseDesign: View {
    @State var courseName: String = ""
    @State var classroom: String = ""
    @State var period: String = ""
    @State var professor: String = ""
    
    let time = Calendar.current.component(.hour, from: Date())
    let timePeriod: [String: Int] = [
        "A": 7, "1": 8, "2": 9, "3": 10, "4": 11,
        "B": 12, "5": 13, "6": 14, "7": 15, "8": 16, "9": 17,"C": 23
    ]
    
    
    var isCurrentCourse: Bool {
        for (key, hour) in timePeriod {
            if hour == time && period.contains(key) {
                return true
            }
        }
        return false
    }

    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 20.0,style: .continuous).fill(Color.blue.opacity(0.4)).frame(height: isCurrentCourse ? 240 : 120).animation(.easeInOut, value: isCurrentCourse)
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading){
                    //TODO: dynamic dots and color change
                    Circle().fill(Color.blue).frame(width: 10, height: 10)
                    Circle().fill(Color.blue).frame(width: 10, height: 10)
                    Circle().fill(Color.blue).frame(width: 10, height: 10)
                    Capsule().fill(Color.blue).frame(width: 10, height: 30)
                }
                VStack(alignment: .leading){
                    Text(courseName).padding(.vertical, 15)
                    Text(period)
                }
                Spacer(minLength: 0.0)
                VStack(alignment: .trailing){
                    Text(classroom)
                    Text(professor)
                }
            }.padding(.horizontal)
        }.padding(.horizontal)
    }
    
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DataItem.self, configurations: config)
        return MainTabView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create preview container: \(error.localizedDescription)")
    }
}

#Preview{
    courseDesign(courseName: "Test", classroom: "Room", period: "A12", professor: "Damn")
}
