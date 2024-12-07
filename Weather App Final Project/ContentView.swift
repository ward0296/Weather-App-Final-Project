//
//  ContentView.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-25.
//

import SwiftUI

struct ContentView: View {
    @State private var cities: [CityItem] = [
    
    ]

    var body: some View {
        TabView {
            CityListView(cities: $cities)
                .tabItem {
                    Label("Cities", systemImage: "list.dash")
                }

            SearchView(cities: $cities)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
