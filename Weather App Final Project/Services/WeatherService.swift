//
//  WeatherService.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import Foundation

struct WeatherService {
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        guard let url = URL(string: "\(Constants.baseURL)?q=\(city)&appid=\(Constants.apiKey)&units=metric") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
