//
//  CityDetailView.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import SwiftUI
import MapKit
import Foundation

struct CityDetailView: View {
    let city: String
    let latitude: Double
    let longitude: Double
    @State private var weather: WeatherResponse? = nil
    @State private var errorMessage: String? = nil
    @State private var region: MKCoordinateRegion
    @State private var isCelsius: Bool = true // this tracks the current temperature unit

    init(city: String, latitude: Double, longitude: Double) {
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }

    var body: some View {
        ZStack {
            // Map Background
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)

            // Temperature-Dependent Overlay
            if let temperature = weather?.main.temp {
                ColorUtils.color(forTemperature: temperature)
                    .opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
            }

            // Foreground Content
            if let weather = weather {
                VStack(spacing: 20) {
                    // City name
                    Text(city)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    // Weather condition
                    Text(weather.weather.first?.description.capitalized ?? "Unknown")
                        .font(.headline)
                        .foregroundColor(.white)

                    // Temperature with toggle functionality
                    Text(isCelsius
                         ? "\(Int(weather.main.temp))°C"
                         : "\(Int(weather.main.temp * 9/5 + 32))°F")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .onTapGesture {
                            isCelsius.toggle()
                        }

                    // Other weather detail
                    HStack {
                        VStack {
                            Text("Humidity")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("\(weather.main.humidity)%")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack {
                            Text("Wind")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("\(weather.wind.speed, specifier: "%.1f") m/s")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack {
                            Text("UV Index")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("N/A") // Placeholder for UV Index
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    
                    Spacer()
                }
                .padding()
            } else if let errorMessage = errorMessage {
                // this will display error message if fetch fails
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                // Loading indicator
                ProgressView("Fetching Weather...")
            }
        }
        .onAppear {
            Task {
                await fetchWeather()
            }
        }
    }

    // this fetches weather for the specified city
    private func fetchWeather() async {
        do {
            weather = try await WeatherService().fetchWeather(for: city)
        } catch {
            errorMessage = "Failed to fetch weather data for \(city)."
        }
    }
}

struct CityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CityDetailView(city: "Toronto", latitude: 43.7, longitude: -79.4)
    }
}
