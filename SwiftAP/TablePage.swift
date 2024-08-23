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
                DayInWeek
                DayInWeek
            }
            
            .navigationTitle("Table")
        }
    }
}

#Preview {
    TablePage()
}


let DayInWeek: some View = VStack{
    Text("Mon").font(.title.bold()).padding([.all],5).minimumScaleFactor(0.5).lineLimit(1)
    VStack {
        Text("Test").font(.title).padding([.all],5).lineLimit(1)
        Text("Score").font(.subheadline).padding([.all],5).lineLimit(1)
    }
}.minimumScaleFactor(0.5)
