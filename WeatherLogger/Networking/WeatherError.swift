//
//  WeatherError.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

class WeatherError: Codable {
    let stat: String
    let code: Int
    let message: String
}
