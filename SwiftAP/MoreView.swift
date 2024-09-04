//
//  MorePage.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct MorePage: View {
    
    
    var body: some View {
        NavigationStack(){
            ZStack(content: {
                Text("More...later")
            })
            .navigationTitle("More")
        }
    }
}

#Preview {
    ContentView()
}
