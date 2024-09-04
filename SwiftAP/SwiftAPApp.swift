//
//  SwiftAPApp.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

@main
struct SwiftAPApp: App {
    @StateObject private var sharedData = SharedData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sharedData)
        }
    }
}
