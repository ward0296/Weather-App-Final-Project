//
//  WeatherData.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import SwiftUI

// Weather Response Model
struct WeatherResponse: Codable {
    let name: String
    let sys: Sys               
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let timezone: Int
}

struct Sys: Codable {
    let country: String       
}

struct Weather: Codable {
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}
