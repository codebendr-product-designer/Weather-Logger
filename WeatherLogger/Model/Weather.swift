//
//  Weather.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let coord: Coord
    let weather: [WeatherElement]
    let main: Main
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
    let main, description, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case description = "description"
        case icon
    }
}
