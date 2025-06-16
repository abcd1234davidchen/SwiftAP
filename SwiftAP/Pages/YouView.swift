import SwiftUI

struct YouView: View {
    var body: some View {
        NavigationStack(){
            ZStack(content: {
                Text("More...later")
            })
            .navigationTitle("Good Day")
        }
    }
}



#Preview {
    MainTabView()
}
