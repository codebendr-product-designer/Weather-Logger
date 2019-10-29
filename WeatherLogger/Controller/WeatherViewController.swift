//
//  ViewController.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtCity: UILabel!
    @IBOutlet weak var txtWeatherDescription: UILabel!
    @IBOutlet weak var txtTemperature: UILabel!
    
    let degreesSign = "°"
    var annotation: PinAnnotation!
    var dataStore: DataStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWeather(coordinate: CLLocationCoordinate2D(latitude: 35, longitude: -139))
    }
    
    
    func loadWeather(coordinate: CLLocationCoordinate2D)  {
        
        guard let restManager = EndPoint.weather.get().restManager else { return }
        
        if let url = EndPoint.weather.get().url {
            
            restManager.parameters.add(value: "\(coordinate.latitude)", forKey: "lat")
            restManager.parameters.add(value: "\(coordinate.longitude)", forKey: "lon")
            //  restManager.parameters.add(value: "accra", forKey: "q")
            
            DispatchQueue.main.async {
            }
            
            restManager.request(url: url, with: .get) {
                results in
                
                if results.error == nil {
                    
                    DispatchQueue.main.async {
                        
                    }
                    
                    guard let data = results.data else {
                        DispatchQueue.main.async {
                            
                        }
                        return
                    }
                    
                    WeatherClient<Weather>().decode(data: data) {
                        result in
                        
                        switch result {
                            
                        case .success(let response):
                            print(response)
                            
                        case .failure(let error):
                            print(error)
                            
                        case .weatherError(let weatherError):
                            print(weatherError)
                            
                        }
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        print("general error")
                    }
                }
            }
        }
    }
    
}

extension WeatherViewController {
    func configureUI(_ isLoading: Bool) {
        loaderView.isHidden = !isLoading
    }
}



