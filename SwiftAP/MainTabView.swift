import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView{
            YouView().tabItem{Label("You",systemImage:"person.crop.circle")}
            ActivityView().tabItem{Label("Activity",systemImage:"square.stack.fill")}
            BusView().tabItem{Label("Bus",systemImage:"bus")}
            MoreView().tabItem{Label("More",systemImage:"square.grid.2x2.fill")}
        }
        .onAppear{
            insertDefaultSettingsIfNeeded()
        }
    }
    private func insertDefaultSettingsIfNeeded(){
        let fetchDescriptor = FetchDescriptor<AppInfo>()
        let settings = try? context.fetch(fetchDescriptor)
        if settings?.isEmpty ?? true {
            let defaultSetting = AppInfo(id: UUID().uuidString, yearSemester: "1132", userName: "")
            context.insert(defaultSetting)
        }
    }
}



#Preview {
    MainTabView()
}
