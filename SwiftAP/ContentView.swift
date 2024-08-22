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
            Text("First").tabItem {Label("First",systemImage:"1.circle")}
            Text("Second").tabItem {Label("Second",systemImage: "2.circle")}
        }
    }
}

#Preview {
    ContentView()
}
