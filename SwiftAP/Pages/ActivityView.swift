import SwiftUI
import SwiftData

struct ActivityView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var activityVM = ActivityViewModel()
    
    let daysOfWeek: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    let timeOrder: [String] = [
        "A","1", "2", "3", "4", "B", "5", "6", "7", "8", "9"
    ]
    let timePeriod: [String: Int] = [
        "A": 7, "1": 8, "2": 9, "3": 10, "4": 11,
        "B": 12, "5": 13, "6": 14, "7": 15, "8": 16, "9": 17
    ]

    private func findCourse(time: String, day: String) -> DataItem? {
        return activityVM.courses.first { course in
            let daySchedule = getDaySchedule(course: course, day: day)
            return daySchedule.contains(time)
        }
    }
    private func getDaySchedule(course: DataItem, day: String) -> String{
        switch day {
            case "Mon": return course.monday
            case "Tue": return course.tuesday
            case "Wed": return course.wednesday
            case "Thu": return course.thursday
            case "Fri": return course.friday
            case "Sat": return course.saturday
            case "Sun": return course.sunday
            default: return ""
        }
    }
        
    private func getContinuousCourses(for day: String) -> [String:(course:DataItem,startIndex: Int, length: Int)]{
        var continuousCourses: [String:(course:DataItem,startIndex: Int, length: Int)] = [:]
        
        for course in activityVM.courses {
            let daySchedule = getDaySchedule(course: course, day: day)
            var startIndex: Int? = nil
            var currentLength = 0
            
            for (index, time) in timeOrder.enumerated() {
                if daySchedule.contains(time) {
                    if startIndex == nil {
                        startIndex = index
                        currentLength = 1
                    } else {
                        currentLength += 1
                    }
                    if let start = startIndex {
                        let key = "\(course.name)_\(start)"
                        continuousCourses[key] = (course, start, currentLength)
                    }
                } else {
                    startIndex = nil
                    currentLength = 0
                }
            }
        }
        return continuousCourses
    }
    
    @ViewBuilder
    private func courseCell(for time: String, day: String) -> some View {
        let continuousCourses = getContinuousCourses(for: day)
        
        if let timeIndex = timeOrder.firstIndex(of: time) {
            if let continuousInfo = continuousCourses.values.first(where: { $0.startIndex == timeIndex }) {
                HStack{
                    VStack(alignment: .leading, spacing: 3) {
                        Text(continuousInfo.course.name)
                            .font(.caption)
                        if !continuousInfo.course.room.isEmpty {
                            Text(continuousInfo.course.room)
                                .font(.system(size: 8))
                                .opacity(0.8)
                        }
                    }.foregroundStyle(.black)
                    Spacer(minLength: 0)
                }
                .padding(.all, 5)
                .frame(maxWidth: .infinity, minHeight:CGFloat(60 * continuousInfo.length), maxHeight:CGFloat(60 * continuousInfo.length))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(hexStringToColor(hex: continuousInfo.course.colorHex, opacity:0.9))
                        .padding(.all, 2)
                )
            }
            else {
                let isOccupied = continuousCourses.values.contains { courseInfo in
                    let endIndex = courseInfo.startIndex + courseInfo.length - 1
                    return timeIndex > courseInfo.startIndex && timeIndex <= endIndex
                }
                if !isOccupied {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.1))
                        .padding(.all, 2)
                        .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                }
            }
        }
    }

    private func showSunday() -> Bool {
        return activityVM.courses.contains { course in
            !course.sunday.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    private func showSaturday() -> Bool {
        return activityVM.courses.contains { course in
            !course.saturday.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }

    var body: some View {
        NavigationStack(){
            ZStack(content: {
                if(activityVM.isLoading){
                    Text("Loading...")
                }
                else{
                    ScrollView(showsIndicators: false) {
                        HStack(spacing:0){
                            VStack(spacing:0){
                                Spacer().frame(height:40)
                                ForEach(timeOrder,id:\.self){time in
                                    Text(time).frame(width: 20, height: 60)
                                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.3)).padding(2))
                                        .font(.caption)
                                }
                            }
                            ForEach(daysOfWeek.filter{day in
                                if day == "Sun" {return showSunday()}
                                else if day == "Sat" {return showSaturday()||showSunday()}
                                return true
                            },id:\.self){day in
                                VStack(spacing:0){
                                    Text(day)
                                        .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40)
                                        .font(.caption)
                                    ForEach(timeOrder, id: \.self) { time in
                                        courseCell(for: time, day: day)
                                    }
                                }
                            }
                        }
                    }
                }
            })
            .navigationTitle("Activity")
            .onAppear {
                activityVM.setupWithContext(context: context)
                activityVM.buildActivityPage(context: context){ success in
                    print("Fetched courses successfully: \(success)")
                }
            }
            .toolbar{
                ToolbarItem{
                    Menu{
                        ForEach(activityVM.availableSemesters, id: \.self){semester in
                            Button(semester) {
                                activityVM.fetchYearSemester = semester
                                activityVM.buildActivityPage(context: context){ success in
                                    print("Fetched courses successfully: \(success)")
                                }
                            }
                        }
                    }label: {
                        Text(activityVM.fetchYearSemester)
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityView()
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
