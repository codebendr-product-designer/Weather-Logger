//
//  Weather.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

// MARK: - Weather
struct Weather: Codable, Hashable {
    
    let id = UUID().uuidString
    let coord: Coord
    let weather: [WeatherElement]
    let main: Main
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Int
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
    let tempMin, tempMax: Double
    let seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, desc, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case desc = "description"
        case icon
    }
}
