import SwiftUI
import SwiftData

struct YouView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var youVM = YouViewModel()
    @Query var courses: [DataItem]

    var body: some View {
        NavigationStack(){
            ZStack(content: {
                List(courses, id: \.id) { course in
                    Text(course.name)
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



#Preview {
    MainTabView()
}
