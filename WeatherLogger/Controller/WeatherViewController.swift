//
//  ViewController.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtCity: UILabel!
    @IBOutlet weak var txtWeatherDescription: UILabel!
    @IBOutlet weak var txtTemperature: UILabel!
    @IBOutlet weak var txtHumidity: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
    let degreesSign = "°"
    var annotation: PinAnnotation!
    var dataStore: DataStore!
    var currentWeather: CurrentWeather!
    var weather: Weather!
    var pin: Pin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI(true)
        
        find(location: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)) {
            placemark in
            
            if let placemark = placemark {
                self.annotation.title = placemark.locality
            }
            
            self.loadWeather(coordinate: CLLocationCoordinate2D(latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude))
            
        }
        
        pin = Pin(context: dataStore.viewContext)
        pin.id = annotation.id
        pin.latitude = annotation.coordinate.latitude
        pin.longitude = annotation.coordinate.longitude
        
    }
    
    func createCurrentWeather() {
        
        currentWeather = CurrentWeather(context: dataStore.viewContext)
        currentWeather.id = UUID().uuidString
        currentWeather.createdAt = Date()
        currentWeather.pinID = pin.id
        currentWeather.city = annotation.title
        currentWeather.prepare(toSave: weather)
        
        guard let image = imageView.image else {return}
        currentWeather.icon = image.pngData()
        
    }
    
    @IBAction func btnActionPressed(_ sender: Any) {
        
        createCurrentWeather()
        
        do {
            try dataStore.viewContext.save()
            self.navigationController?.popToRootViewController(animated: true)
        } catch {
            DispatchQueue.main.async {
                self.present(Alert.show(.saveError),animated:true)
            }
        }
    }
    
}

extension WeatherViewController {
    
    func loadWeather(coordinate: CLLocationCoordinate2D)  {
        
        guard let restManager = EndPoint.weather.get().restManager else { return }
        
        if let url = EndPoint.weather.get().url {
            
            restManager.parameters.add(value: "\(coordinate.latitude)", forKey: "lat")
            restManager.parameters.add(value: "\(coordinate.longitude)", forKey: "lon")
            //  restManager.parameters.add(value: "accra", forKey: "q")
            
            DispatchQueue.main.async {
                self.configureUI(true)
            }
            
            restManager.request(url: url, with: .get) {
                results in
                
                if results.error == nil {
                    
                    DispatchQueue.main.async {
                        self.configureUI(false)
                    }
                    
                    guard let data = results.data else {
                        DispatchQueue.main.async {
                            
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
    
    func find(location: CLLocation, placemark: @escaping (CLPlacemark?) -> Void) {
        let geocode = CLGeocoder()
        geocode.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil {
                if let placemarks = placemarks {
                    placemark(placemarks[0])
                }
            }
        }
    }
    
    func configureUI(_ isLoading: Bool) {
        loaderView.isHidden = !isLoading
    }
    
    func configure(with response: Weather){
        let weather = response.weather[0]
        let main = response.main
        imageView.download(from: WeatherClient.get(weather.icon))
        txtCity.text = annotation.title
        txtWeatherDescription.text = weather.desc
        txtTemperature.text = main.temp.celsius()
        txtHumidity.text = "HUMIDITY \(main.humidity)%"
    }
    
    
    
    
    
}





