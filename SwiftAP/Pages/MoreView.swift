import SwiftUI
import SwiftData

struct MoreView: View {
    @EnvironmentObject var auth:Auth
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack(){
            ZStack(content: {
                Text("More...later")
            })
            .navigationTitle("More")
            .toolbar{ToolbarItem(placement: .topBarTrailing){
                Button("Logout"){
                    do {
                        let fetchDescriptor = FetchDescriptor<DataItem>()
                        let items = try context.fetch(fetchDescriptor)
                        for item in items {
                            context.delete(item)
                        }
                        try context.save()
                    } catch {
                        print("Failed to clear data: \(error)")
                    }
                    do {
                        let fetchDescriptor = FetchDescriptor<AppInfo>()
                        let items = try context.fetch(fetchDescriptor)
                        for item in items {
                            context.delete(item)
                        }
                        try context.save()
                    } catch {
                        print("Failed to clear data: \(error)")
                    }
                    auth.updateValidation(success: false)
                }
            }}
        }
    }
}

#Preview {
    MainTabView()
}
