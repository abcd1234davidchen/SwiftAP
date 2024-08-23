//
//  TablePage.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct TablePage: View {
    var body: some View {
        NavigationStack(){
            HStack{
                DayView(day: "Mon")
                DayView(day: "Tue")
            }
            
            .navigationTitle("Table")
            
            .toolbar{
                ToolbarItem(){
                    Button(action: {}, label: {
                        Label(
                            title: { Text("Label") },
                            icon: { Image(systemName: "rectangle.portrait.and.arrow.forward") }
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

struct CourseView: View {
    var name: String
    var additonal: String
    
    var body: some View{
        VStack {
            Text(name)
                .font(.title)
                .padding(5)
                .lineLimit(1)
            Text(additonal)
                .font(.subheadline)
                .padding(5)
                .lineLimit(1)
        }
        .frame(width: 100, height: 100)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        
    }
}

struct DayView: View{
    var day: String
    
    var body: some View{
        VStack{
            Text(day).font(.title.bold()).padding([.all],5).minimumScaleFactor(0.5).lineLimit(1)
            CourseView(name: "Test",additonal: "What")
        }
    }
}
