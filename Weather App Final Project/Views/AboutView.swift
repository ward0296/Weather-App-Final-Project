//
//  AboutView.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import SwiftUI

struct AboutView: View {
    @State private var showHiddenImage = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.black.opacity(0.2), Color.teal], startPoint: .bottom, endPoint: .topLeading)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // App Information
                Text("About WeatherApp")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text("WeatherApp provides real-time weather updates for multiple cities, keeping you informed with a user-friendly design.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.white)
                
                // Developer name
                Text("Developed by Ahmed Wardhere")
                    .font(.headline)
                    .padding(.top)
                    .foregroundColor(.white)
                
                // Hidden Feature
                if showHiddenImage {
                    Image("a.sunset")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                       
                }
                
                Spacer()
                
                // Tell user to trigger the hidden feature
                Text("Tap on the image below 3 times!")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                // This is the trigger for the hidden feature
                Image("a.rainforest")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .onTapGesture(count: 3) { // 3 taps to reveal the hidden feature
                        showHiddenImage.toggle()
                    }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}

