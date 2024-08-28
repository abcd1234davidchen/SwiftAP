//
//  TablePage.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct TablePage: View {
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(daysOfWeek, id: \.self) { day in
                        if let courses = coursesByDay[day],!courses.isEmpty{
                            DayView(day:day,courses:courses)
                        }
                    }
                    //Text("No score yet")
                }
                .padding()
        
            }
            .navigationTitle("Table")
            .toolbar{
                ToolbarItem(){
                    Button(action: {}, label: {
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
            }
        }
    }
}

#Preview {
    TablePage()
}

