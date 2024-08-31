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
    var Time: String
}

struct CourseView: View {
    var course : Course
    var isToday : Bool
    
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
            Text(convertedTime(code: course.Time) ?? "Undefined")
                .font(.caption)
                .padding([.top],3)
            Spacer()
        }
        .frame(width: 150)
        .background(isToday && course.Time.contains(getCurrentTimeCode()!) ? Color.accentColor : Color.secondary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        
    }
}

struct DayView: View{
    var day: String
    var courses:[Course]
    
    var body: some View{
        VStack{
            var istoday: Bool = day==dayInWeek()
            Text(day).font(.title2.bold()).minimumScaleFactor(0.3).padding(.horizontal,10)
                .background(istoday ? Color.red : Color.clear).clipShape(Capsule()).foregroundStyle(istoday ? Color.white:Color.primary)
            ForEach(courses, id: \.name) { course in
                CourseView(course: course, isToday: istoday)
            }.padding(3)
        }
    }
}

#Preview {
    TablePage()
}
