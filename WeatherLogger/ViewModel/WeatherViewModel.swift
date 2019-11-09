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
    
    init(weather: CurrentWeather) {
        self.weather = weather
    }
    
    var name: String {
        return self.order.name
    }
    
    var size: String {
        return self.order.size
    }
    
    var coffeeName: String {
        return self.order.coffeeName
    }
    
    var total: Double {
        return self.order.total
    }
}


