//
//  CurrentWeather+extension.swift
//  WeatherLogger
//
//  Created by codebendr on 29/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

extension CurrentWeather {
    func prepare(toSave response: Weather){
         let weather = response.weather[0]
         let main = response.main
         self.title = weather.main
         self.subtitle = weather.desc
         self.temperature = main.temp
         self.humidity = "\(main.humidity)"
     }
}
