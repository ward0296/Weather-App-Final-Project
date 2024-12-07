//
//  SearchView.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import SwiftUI

struct SearchView: View {
    @Binding var cities: [CityItem] 
    @State private var availableCities: [String] = [
         "Paris", "New York", "Berlin", "London", "Singapore", "Madrid", "Sydney", "Mumbai","Barcelona", "Vancouver"
    ]
    @State private var cityName: String = "" // this is the input for search bar
    @State private var isAddingCity: [String: Bool] = [:]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color.black.opacity(0.2), Color.teal], startPoint: .bottom, endPoint: .topLeading)
                    .ignoresSafeArea()

                VStack {
                    // Search Bar
                    TextField("Enter city name", text: $cityName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disableAutocorrection(true)

                    // Search Button
                    Button(action: {
                        Task {
                            await addSearchedCity()
                        }
                    }) {
                        Text("Search")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    // Hardcoded City List
                    List {
                        ForEach(availableCities, id: \.self) { city in
                            HStack {
                                Text(city)
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        isAddingCity[city] = true
                                    }
                                    Task {
                                        await addCity(city)
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        isAddingCity[city] = false
                                    }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(isAddingCity[city] == true ? .green : .blue)
                                        .scaleEffect(isAddingCity[city] == true ? 1.2 : 1.0)
                                        .animation(.spring(), value: isAddingCity[city] == true)
                                }
                            }
                            .contentShape(Rectangle())
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding()
            }
            .navigationTitle("Search Cities")
        }
    }

    // Add a city from the search bar
    private func addSearchedCity() async {
        guard !cityName.isEmpty else { return }

        // this check for duplicates
        if cities.contains(where: { $0.name.lowercased() == cityName.lowercased() }) {
            return
        }

        // Fetch weather data for the searched city
        do {
            let weather = try await WeatherService().fetchWeather(for: cityName)
            cities.append(
                CityItem(
                    name: cityName,
                    temperature: Int(weather.main.temp),
                    weatherCondition: weather.weather.first?.description.capitalized ?? "Unknown",
                    weatherIcon: determineWeatherIcon(for: weather.weather.first?.main ?? "Clear"),
                    localTime: calculateLocalTime(using: weather.timezone)
                )
            )
            cityName = "" // Clear the search bar
        } catch {
            print("Error fetching weather for \(cityName): \(error.localizedDescription)")
        }
    }

    // Add a city from the hardcoded list
    private func addCity(_ cityName: String) async {
        guard !cities.contains(where: { $0.name == cityName }) else { return }

        do {
            let weather = try await WeatherService().fetchWeather(for: cityName)
            cities.append(
                CityItem(
                    name: cityName,
                    temperature: Int(weather.main.temp),
                    weatherCondition: weather.weather.first?.description.capitalized ?? "Unknown",
                    weatherIcon: determineWeatherIcon(for: weather.weather.first?.main ?? "Clear"),
                    localTime: calculateLocalTime(using: weather.timezone)
                )
            )
        } catch {
            print("Error fetching weather for \(cityName): \(error.localizedDescription)")
        }
    }

    // Helper to determine the weather icon
    private func determineWeatherIcon(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return "sun.max.fill"
        case "clouds":
            return "cloud.fill"
        case "rain":
            return "cloud.rain.fill"
        case "snow":
            return "cloud.snow.fill"
        default:
            return "questionmark.circle"
        }
    }

    private func calculateLocalTime(using timezoneOffset: Int) -> String {
        let utcTime = Date() // Current UTC time
        let localTime = utcTime.addingTimeInterval(TimeInterval(timezoneOffset)) // Adding timezone offset
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        formatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset) // this sets formatter to the city's timezone
        return formatter.string(from: localTime)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(cities: .constant([]))
    }
}

