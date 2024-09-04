//
//  ContentView.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var sharedData = SharedData()
    
    var body: some View {
        TabView{
            TablePage().tabItem{Label("You",systemImage:"person.crop.circle")}
                .environmentObject(sharedData)
            ActivityPage().tabItem{Label("Activity",systemImage:"rectangle.stack")}
                .environmentObject(sharedData)
            MorePage().tabItem{Label("More",systemImage:"square.grid.2x2.fill")}
        }
    }
    
}

#Preview {
    ContentView()
}
