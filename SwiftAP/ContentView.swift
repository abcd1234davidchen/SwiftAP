//
//  ContentView.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct ContentView: View {
    
    init() {
            setupTabBarAppearance()
        }
    
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
    
    private func setupTabBarAppearance() {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)

            UITabBar.appearance().standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
}

#Preview {
    ContentView()
}
