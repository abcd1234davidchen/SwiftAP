import SwiftUI

struct ActivityView: View {
    var body: some View {
        NavigationStack(){
            ZStack(content: {
                Text("More...later")
            })
            .navigationTitle("Activity")
        }
    }
}

#Preview {
    MainTabView()
}
