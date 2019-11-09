//
//  WeatherViewModel.swift
//  WeatherLogger
//
//  Created by codebendr on 05/11/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol WeatherListViewModelDelegate: class {
    func preloader(_ isLoading: Bool)
    func onDataFailed()
}

final class WeatherViewModel {
    
    let id = UUID().uuidString
    let delegate: WeatherListViewModelDelegate
    
    var weather: Weather
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    var city: String {
        if let city = weather.city {
            return city
        } else {
            return ""
        }
    }
    
    var temperature: String {
        return weather.temperature.celsius()
    }
    
    var humidity: String {
        if let humidity = self.weather.humidity {
            return String(format: "%.0f", humidity)
        } else {
            return ""
        }
    }
    
    var icon: Data? {
        guard let icon = weather.icon else { return nil }
        return icon
    }
    
    func fetch (coordinate: CLLocationCoordinate2D) {
        
        guard let restManager = EndPoint.weather.get().restManager else { return }
        
        if let url = EndPoint.weather.get().url {
            
            restManager.parameters.add(value: "\(coordinate.latitude)", forKey: "lat")
            restManager.parameters.add(value: "\(coordinate.longitude)", forKey: "lon")
            
            DispatchQueue.main.async {
                self.delegate.preloader(true)
            }
            
            restManager.request(url: url, with: .get) {
                results in
                
                if results.error == nil {
                    
                    DispatchQueue.main.async {
                        self.delegate.preloader(false)
                    }
                    
                    guard let data = results.data else {
                        DispatchQueue.main.async {
                            self.delegate.onDataFailed()
                            // self.present(Alert.show(.general), animated: true)
                        }
                        return
                    }
                    
                    WeatherClient.decode(Weather.self,data: data) {
                        result in
                        
                        switch result {
                            
                        case .success(let response):
                            self.weather = response
                            DispatchQueue.main.async {
                                self.configure(with: response)
                            }
                            
                        case .failure(_):
                            DispatchQueue.main.async {
                                self.present(Alert.show(.server), animated: true)
                            }
                            
                        case .weatherError(let weatherError):
                            DispatchQueue.main.async {
                                let alert = Alert.show(.weatherDeletion, message: weatherError.message)
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.delegate.onDataFailed()
                        // self.present(Alert.show(.general), animated: true)
                    }
                }
            }
        }
    }
}


