//
//  ColorUtils.swift
//  Weather App Final Project
//
//  Created by Ahmed  on 2024-11-26.
//

import SwiftUI

struct ColorUtils {
    static func color(forTemperature temperature: Double) -> Color {
        switch temperature {
        case ..<15: // Cold weather
            return Color.blue
        case 15..<30: // Mild weather
            return Color.yellow
        default:
            return Color.red // Hot weather
        }
    }
}

