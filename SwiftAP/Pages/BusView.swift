import SwiftUI

struct BusView: View {
    var body: some View {
        NavigationStack(){
            ZStack(content: {
                Text("More...later")
            })
            .navigationTitle("Bus")
        }
    }
}

#Preview {
    MainTabView()
}
