//
//  WeatherData.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import SwiftUI

// Weather Response Model
struct WeatherResponse: Codable {
    let name: String           // City name
    let sys: Sys               
    let weather: [Weather]     // Weather conditions
    let main: Main             // Main weather details
    let wind: Wind             // Wind data
    let timezone: Int          // Timezone UTC
}

struct Sys: Codable {
    let country: String        // Country code (e.g., "US")
}

struct Weather: Codable {
    let main: String           // General weather condition (example: "Clear")
    let description: String    // Weather description (example: "clear sky")
    let icon: String
}

struct Main: Codable {
    let temp: Double           // Temperature in Celsius
    let humidity: Int          // Humidity percentage
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}
