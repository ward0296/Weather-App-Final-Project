//
//  SettingsView.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import SwiftUI

struct SettingsView: View {
    @State private var refreshInterval = 60

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black.opacity(0.2), Color.teal], startPoint: .bottom, endPoint: .topLeading)
                .ignoresSafeArea()

            VStack {
                NavigationView {
                    Form {
                        Section(header: Text("Refresh Interval")) {
                            Stepper(value: $refreshInterval, in: 5...60, step: 5) {
                                Text("\(Int(refreshInterval)) seconds")
                                    .foregroundColor(.primary)
                            }
                        }

                        Section {
                            NavigationLink(destination: AboutView()) {
                                Text("About")
                            }
                        }
                    }
                    .scrollContentBackground(.hidden) 
                    .background(Color.clear) // this maks sure the form is transparent/clear
                    .navigationTitle("Settings")
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
