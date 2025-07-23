import SwiftUI
import SwiftData

struct YouView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @StateObject private var youVM = YouViewModel()
    @Query var courses: [DataItem]

    func courseString(course: DataItem) -> String {
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
        return str
    }
    
    var todayCourses: [DataItem] {
        courses.filter { course in
            let str = courseString(course: course)
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
            let str = courseString(course: course)
            for (key, hour) in timePeriod {
                if hour >= time && str.contains(key) {
                    return true
                }
            }
            return false
        }
    }
    
    var sortedCourses: [DataItem] {
        let timePeriodOrder: [String] = ["A", "1", "2", "3", "4", "B", "5", "6", "7", "8", "9", "C"]
        var courseWithEarliestPeriod: [(course: DataItem, earliestIndex: Int)] = []
        var added = Set<String>()
        for course in upcomingCourses {
            let str = courseString(course: course)
            let indices = timePeriodOrder.compactMap { key in
                str.contains(key) ? timePeriodOrder.firstIndex(of: key) : nil
            }
            if let minIndex = indices.min(), !added.contains(course.name) {
                courseWithEarliestPeriod.append((course, minIndex))
                added.insert(course.name)
            }
        }
        return courseWithEarliestPeriod.sorted { $0.earliestIndex < $1.earliestIndex }.map { $0.course }
    }

    var body: some View {
        NavigationStack(){
            ZStack(content: {
                Group {
                    if horizontalSizeClass == .compact {
                        ScrollView {
                            VStack{
                                ForEach(sortedCourses.indices, id: \.self){index in
                                    let course = sortedCourses[index]
                                    courseDesign(courseName: course.name, classroom: course.room, period: courseString(course: course), professor: course.professor, colorHex: course.colorHex, index: index)
                                }
                            if(sortedCourses.isEmpty){
                                Image(systemName: "square.3.layers.3d.down.right.slash").font(.system(size: 60))
                                Text("No Courses").font(.title)
                            }
                            }.frame(maxHeight: .infinity, alignment: .topLeading)
                            Divider().padding()
                            VStack{
                                Image(systemName: "bell.slash").font(.system(size: 60))
                                Text("No Announcements").font(.title)
                            }
                        }
                    }
                    else{
                        ScrollView(.horizontal){
                            HStack {
                                if(sortedCourses.isEmpty){
                                    VStack{
                                        Image(systemName: "square.3.layers.3d.down.right.slash").font(.system(size: 60))
                                        Text("No Courses").font(.title)
                                    }.frame(minWidth : 450,alignment: .center)
                                }
                                else{
                                    ScrollView{
                                        VStack{
                                            ForEach(sortedCourses.indices, id: \.self){index in
                                                let course = sortedCourses[index]
                                                courseDesign(courseName: course.name, classroom: course.room, period: courseString(course: course), professor: course.professor, colorHex: course.colorHex, index: index)
                                            }
                                            if(sortedCourses.isEmpty){
                                                Image(systemName: "square.3.layers.3d.down.right.slash").font(.system(size: 60))
                                                Text("No Courses").font(.title)
                                            }
                                        }.frame(minWidth : 500, maxHeight: .infinity ,alignment: .center)
                                    }
                                }
                                Divider().padding()
                                VStack{
                                    Image(systemName: "bell.slash").font(.system(size: 60))
                                    Text("No Announcements").font(.title)
                                }.frame(minWidth : 450,alignment: .center)
                            }
                        }
                    }
                }
            })
            .navigationTitle("Swift AP")
            .onAppear{
                youVM.buildYouPage(context: context) { success in
                    print("Fetched courses successfully: \(success)")
                }
            }
        }
    }
}

struct courseDesign: View {
    var courseName: String = ""
    var classroom: String = ""
    var period: String = ""
    var professor: String = ""
    @State var colorHex: String = ""
    @State var index: Int = 0
    
    @State private var time = Calendar.current.component(.hour, from: Date())
    let timePeriod: [String: Int] = [
        "A": 7, "1": 8, "2": 9, "3": 10, "4": 11,
        "B": 12, "5": 13, "6": 14, "7": 15, "8": 16, "9": 17
    ]
    
    var isCurrentCourse: Bool {
        return index == 0
    }
    
    var periodArr : [String] {
        return period.map { String($0) }
    }
    
    var timeString : String{
        return "\(timePeriod[periodArr.first ?? "A"] ?? 0):10~\((timePeriod[periodArr.last ?? "A"] ?? 0)+1):00"
    }

    var body: some View {
        ZStack(alignment: .leading){
            RoundedRectangle(cornerRadius: 20.0,style: .continuous).fill(hexStringToColor(hex: colorHex, opacity: 0.3)).frame(height: isCurrentCourse ? 150 : 120).animation(.easeInOut, value: isCurrentCourse)
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading){
                    ForEach(periodArr, id: \.self){periodTime in
                        let active = timePeriod[periodTime]==time && isCurrentCourse
                        Capsule().fill(hexStringToColor(hex: colorHex)).frame(width: 10, height: active ? 60 : 10)
                    }
                }
                VStack(alignment: .leading){
                    Text(courseName)
                        .font(isCurrentCourse ? (courseName.count > 40 ? .title : .largeTitle) : (courseName.count > 18 ? .title3 : .title))
                        .frame(height: isCurrentCourse ? 90 : 60)
                    HStack(alignment: .bottom){
                        Text(timeString).font(.title3)
                        Spacer(minLength: 0.0)
                        VStack(alignment: .trailing){
                            Text(classroom).font(.callout)
                            Text(professor).font(.callout)
                        }
                    }
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

#Preview {
    ScrollView(showsIndicators: false){
        ForEach(colorHexList, id: \.self) { colorHex in
            courseDesign(courseName: "PYTHON AND MACHINE LEARNING ALGORITHMS".capitalized, classroom: "三5,6,7(工EC 1005)", period: "A1234", professor: "教授名字可以不要太長嗎",colorHex: colorHex, index: 0)
            courseDesign(courseName: "PYTHON AND MACHINE LEARNING ALGORITHMS".capitalized, classroom: "三5,6,7(工EC 1005)", period: "A1234", professor: "教授名字可以不要太長嗎",colorHex: colorHex, index: 1)
        }
    }
}

#Preview {
    let columns = Array(repeating: GridItem(), count: 4)
    ScrollView{
        LazyVGrid(columns:columns){
            ForEach(colorHexList, id: \.self) { colorHex in
                ZStack{
                    RoundedRectangle(cornerRadius: 20.0,style: .continuous).fill(hexStringToColor(hex: colorHex, opacity: 0.3)).frame(height:120)
                    Circle().fill(hexStringToColor(hex: colorHex, opacity: 1)).frame(width: 10, height: 10)
                }.padding(.horizontal)
            }
        }
    }
}
