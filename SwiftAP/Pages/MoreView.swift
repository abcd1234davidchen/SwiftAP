import SwiftUI

struct MoreView: View {
    @EnvironmentObject var auth:Auth
    var body: some View {
        NavigationStack(){
            ZStack(content: {
                Text("More...later")
            })
            .navigationTitle("More")
            .toolbar{ToolbarItem(placement: .topBarTrailing){
                Button("Logout"){
                    auth.updateValidation(success: false)
                }
            }}
        }
    }
}

#Preview {
    MainTabView()
}
