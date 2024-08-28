//
//  TableElements.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/28.
//

import SwiftUI

struct Course{
    var name : String
    var additionalData : String
}

struct CourseView: View {
    var course : Course
    
    var body: some View{
        VStack {
            Spacer()
            Text(course.name)
                .font(.title)
                .padding(5)
                .minimumScaleFactor(0.3)
                .multilineTextAlignment(.center)
            Text(course.additionalData)
                .font(.subheadline)
                .minimumScaleFactor(0.3)
            Spacer()
        }
        .frame(width: 150)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        
    }
}

struct DayView: View{
    var day: String
    var courses:[Course]
    
    var body: some View{
        VStack{
            Text(day).font(.title2.bold()).minimumScaleFactor(0.3)
            ForEach(courses, id: \.name) { course in
                CourseView(course: course)
            }.padding(3)
        }
    }
}

#Preview {
    TablePage()
}
