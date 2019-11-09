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
    func onPreloader(_ isLoading: Bool)
    func onDataFailed()
    func onWeatherSuccess(_ response: Weather)
    func onWeatherFailure()
    func onWeatherError(weatherError: WeatherError)
}

final class WeatherViewModel {
    
    let delegate: WeatherListViewModelDelegate
    
    init(delegate: WeatherListViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetch (coordinate: CLLocationCoordinate2D) {
        
        guard let restManager = EndPoint.weather.get().restManager else { return }
        
        if let url = EndPoint.weather.get().url {
            
            restManager.parameters.add(value: "\(coordinate.latitude)", forKey: "lat")
            restManager.parameters.add(value: "\(coordinate.longitude)", forKey: "lon")
            
            DispatchQueue.main.async {
                self.delegate.onPreloader(true)
            }
            
            restManager.request(url: url, with: .get) {
                results in
                
                if results.error == nil {
                    
                    DispatchQueue.main.async {
                        self.delegate.onPreloader(false)
                    }
                    
                    guard let data = results.data else {
                        DispatchQueue.main.async {
                            self.delegate.onDataFailed()
                        }
                        return
                    }
                    
                    WeatherClient.decode(Weather.self,data: data) {
                        result in
                        
                        switch result {
                            
                        case .success(let response):
                            DispatchQueue.main.async {
                                self.delegate.onWeatherSuccess(response)
                            }
                            
                        case .failure(_):
                            DispatchQueue.main.async {
                                self.delegate.onWeatherFailure()
                            }
                            
                        case .weatherError(let weatherError):
                            DispatchQueue.main.async {
                                self.delegate.onWeatherError(weatherError: weatherError)
                            }
                            
                        }
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.delegate.onDataFailed()
                    }
                }
            }
        }
    }
}


