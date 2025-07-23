import SwiftUI
import SwiftData

struct ActivityView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var activityVM = ActivityViewModel()

    var body: some View {
        NavigationStack(){
            ZStack(content: {
                if(activityVM.isLoading){
                    Text("WAIT")
                }
                else{
                    VStack{
                        ForEach(activityVM.courses){course in
                            Text(course.name)
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
