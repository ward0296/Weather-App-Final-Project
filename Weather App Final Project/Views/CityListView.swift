//
//  CityListView.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import SwiftUI

struct CityListView: View {
    @Binding var cities: [CityItem]
    @State private var showDeleteConfirmation = false
    @State private var cityToDelete: CityItem?

    @AppStorage("refreshInterval") private var refreshInterval: Double = 10.0
    @State private var timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color.black.opacity(0.2), Color.teal], startPoint: .bottom, endPoint: .topLeading)
                    .ignoresSafeArea()

                VStack {
                    if cities.isEmpty {
                        Text("No cities added yet")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        List {
                            ForEach(cities) { city in
                                NavigationLink(destination: CityDetailView(city: city.name,latitude: city.latitude ?? 0.0,longitude: city.longitude ?? 0.0)) {
                                    HStack {
                                        CityRow(city: city)
                                        Spacer()
                                        // Trash icon for deleting a city in list
                                        Button(action: {
                                            cityToDelete = city
                                            showDeleteConfirmation = true
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                                .font(.title2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .listRowBackground(Color.clear)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .onReceive(timer) { _ in
                            Task {
                                await updateCityData()
                            }
                        }
                    }
                }
                .padding([.leading, .trailing])
            }
            .navigationBarTitle("City Weather List", displayMode: .inline)
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Delete City"),
                    message: Text("Are you sure you want to delete \(cityToDelete?.name ?? "this city")?"),
                    primaryButton: .destructive(Text("Yes")) {
                        if let city = cityToDelete {
                            deleteCity(city: city)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    func updateCityData() async {
        for index in cities.indices {
            do {
                let weather = try await WeatherService().fetchWeather(for: cities[index].name)
                cities[index].temperature = Int(weather.main.temp)
                cities[index].weatherCondition = weather.weather.first?.description.capitalized ?? "Unknown"
                cities[index].weatherIcon = determineWeatherIcon(for: weather.weather.first?.main ?? "Clear")
                let utcTime = Date()
                let timezoneOffset = weather.timezone
                let localTime = utcTime.addingTimeInterval(TimeInterval(timezoneOffset - TimeZone.current.secondsFromGMT()))
                cities[index].localTime = formatTime(localTime)
            } catch {
                cities[index].weatherCondition = "Error"
            }
        }
    }

    func deleteCity(city: CityItem) {
        cities.removeAll { $0.id == city.id }
    }

    func determineWeatherIcon(for condition: String) -> String {
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

    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }

    // Inline view for city rows
    private struct CityRow: View {
        let city: CityItem

        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(city.name)
                        .font(.headline)
                    Text(city.localTime)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .center) {
                    Text(city.temperature != nil ? "\(city.temperature!)°C" : "--°C")
                        .font(.title)
                        .fontWeight(.bold)
                    Text(city.weatherCondition)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: city.weatherIcon)
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
            }
            .padding(.vertical, 5)
        }
    }
}

struct CityListView_Previews: PreviewProvider {
    static var previews: some View {
        CityListView(cities: .constant([
            CityItem(name: "Toronto", latitude: 43.7, longitude: -79.4, temperature: nil, weatherCondition: "Loading...", weatherIcon: "cloud.sun.fill", localTime: "--:--")
        ]))
    }
}



