//
//  WeatherViewModel.swift
//  WeatherLogger
//
//  Created by codebendr on 05/11/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

class WeatherListViewModel {
    
    var weatherList = [OrderViewModel]()
    
    init() {
       // fetchOrders()
    }
    
    func fetchWeatherCondition() {
        
//        Webservice().getAllOrders { orders in
//            if let orders = orders {
//                self.orders = orders.map(OrderViewModel.init)
//            }
//
//        }
        
    }
    
}

class WeatherViewModel {
    
    let id = UUID().uuidString
    
    var weather: CurrentWeather
    
    /*
     txtCity.text = weather.city
            txtWeatherDescription.text = weather.subtitle
            txtTemperature.text = weather.temperature.celsius()
            txtHumidity.text = "HUMIDITY \(weather.humidity!)%"
            
            guard let icon = weather.icon else { return }
            imageView.image = UIImage(data: icon)
     */
     
    
    init(weather: CurrentWeather) {
        self.weather = weather
    }
    
    var city: String {
        return weather.city ?? ""
    }
    
    var temperature: String {
        return weather.temperature.celsius()
    }
    
    var humidity: String {
        return "HUMIDITY \(weather.humidity!)%"
    }
    
    var icon: Data {
        return (weather.icon ?? nil) ?? <#default value#> 
    }
}


