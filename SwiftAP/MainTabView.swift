import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            YouView().tabItem{Label("You",systemImage:"person.crop.circle")}
            ActivityView().tabItem{Label("Activity",systemImage:"square.stack.fill")}
            BusView().tabItem{Label("Bus",systemImage:"bus")}
            MoreView().tabItem{Label("More",systemImage:"square.grid.2x2.fill")}
        }
    }
    
}

#Preview {
    MainTabView()
}
