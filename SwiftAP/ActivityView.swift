//
//  HomePage.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct ActivityPage: View {
    @EnvironmentObject var sharedData: SharedData

    var body: some View {
        NavigationStack(){
            VStack{
                let today = sharedData.coursesByDay[dayInWeek()!]
                if ((today?.isEmpty) == nil){
                    Text("You're free now!\n Go have a life").fontWeight(.semibold).multilineTextAlignment(.center).font(.title2)
                }
                else{
                    ForEach(today!,id: \.self){oneCourse in
                        if oneCourse.Time.contains(getCurrentTimeCode()!){
                            Text(oneCourse.name)
                        }
                    }
                }
            }.navigationTitle("Activity")
        }
    }
}

#Preview {
    ContentView()
}
