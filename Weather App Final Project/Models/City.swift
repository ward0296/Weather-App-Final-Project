//
//  City.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import Foundation

struct CityItem: Identifiable {
    let id = UUID()
    let name: String
    var latitude: Double? 
    var longitude: Double?
    var temperature: Int?
    var weatherCondition: String
    var weatherIcon: String
    var localTime: String
}
