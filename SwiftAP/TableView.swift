//
//  TablePage.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct TablePage: View {
    @StateObject private var viewModel = CourseViewModel()
    @EnvironmentObject var sharedData: SharedData
    
    @State var login : Bool = true
    @State var username : String = ""
    @State var password : String = ""
    
    var body: some View {
        login ? AnyView(LoggedInTable) : AnyView(UnloggedIn)
    }
    
    private var LoggedInTable: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(daysOfWeek, id: \.self) { day in
                        if let courses = sharedData.coursesByDay[day],!courses.isEmpty{
                            DayView(day:day,courses:courses)
                        }
                    }
                    //Text("No score yet")
                }
                .padding()
        
            }
            .navigationTitle("Hi")
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItem(){
                    Button(action: {login = false}, label: {
                        Label(
                            title: { Text("Logout") },
                            icon: { Image(systemName: "rectangle.portrait.and.arrow.forward") }
                        )
                    })
                };
                ToolbarItem(){
                    Button(action: {}, label: {
                        Label(
                            title: { Text("Semsester") },
                            icon: { Image(systemName: "menucard") }
                        )
                    })
                }
            }.onAppear {
                if !username.isEmpty {
                    viewModel.getCourseDate(username: username, sharedData: sharedData)
                }
                else{
                    viewModel.getCourseDate(username: "B123245006", sharedData: sharedData)
                }
            }
        }
    }
    
    private var UnloggedIn: some View{
        NavigationStack {
            TextField("Student ID", text: $username).padding()
            SecureField("Password", text: $password).padding()
            Button(action: {login = true}, label: {
                Text("Login")
            })
            .navigationTitle("Login")
        }
    }
    
}
#Preview {
    ContentView()
}

