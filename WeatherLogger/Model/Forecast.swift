//
//  Weather.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let timezone, sunrise, sunset: Int
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [WeatherElement]
    let clouds: Clouds
    let wind: Wind
    let sys: Sys
    let dtTxt: String
    let snow, rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
        case snow, rain
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
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
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
