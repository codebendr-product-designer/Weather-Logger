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
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let wind: Wind
    let rain: Rain
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
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

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let sunrise, sunset: Int
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

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
