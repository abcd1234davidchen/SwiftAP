//
//  ContentView.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        TabView{
            HomePage().tabItem
                {Label("Activity",systemImage:"rectangle.stack")}
            TablePage().tabItem
                {Label("You",systemImage:"person.crop.circle.fill")}
            MorePage().tabItem
                {Label("More",systemImage:"square.grid.2x2.fill")}
        }
    }
    
}

#Preview {
    ContentView()
}
