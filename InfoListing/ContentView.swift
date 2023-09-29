//
//  ContentView.swift
//  InfoListing
//
//  Created by Gefei Shen on 9/29/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .onAppear{
                    Task {
                        let list = try? await NetworkManager().fetchList()
                        print(list)
                    }

                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
