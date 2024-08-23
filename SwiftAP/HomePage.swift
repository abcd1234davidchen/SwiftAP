//
//  HomePage.swift
//  SwiftAP
//
//  Created by David Chen on 2024/8/23.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack(){
            ZStack(content: {
                Text("What")
            })
            .navigationTitle("Activity")
        }
    }
}

#Preview {
    HomePage()
}
