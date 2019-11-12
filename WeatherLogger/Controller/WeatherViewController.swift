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

class WeatherViewController: UIViewController, StoryboardController {
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtCity: UILabel!
    @IBOutlet weak var txtWeatherDescription: UILabel!
    @IBOutlet weak var txtTemperature: UILabel!
    @IBOutlet weak var txtHumidity: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
    var annotation: PinAnnotation!
    var currentWeather: CurrentWeather!
    var weather: Weather!
    var pin: Pin!
    var id:String?
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = id {
            
            btnAction.backgroundColor = .red
            btnAction.setTitle("Delete", for: .normal)
            
            coordinator?.dataStore.search(CurrentWeather.self, with: id){
                weatherList in
                guard let weatherList = weatherList as? [CurrentWeather] else { return }
                DispatchQueue.main.async {
                    if weatherList.count == 1 {
                        self.configure(with: weatherList[0])
                    } else {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
            
        } else {
            
            if RestManager.isNetworkReachable(url: "https://openweathermap.org/") {
                
                configureUI(true)
                
                find(location: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)) {
                    placemark in
                    
                    if let placemark = placemark {
                        self.annotation.title = placemark.locality
                    }
                    
                    WeatherViewModel(delegate: self).fetch(coordinate: CLLocationCoordinate2D(latitude: self.annotation.coordinate.latitude, longitude: self.annotation.coordinate.longitude))
                    
                }
                
                createPin()
                
            } else {
                present(Alert.show(.networkError, message: "The internet connection is offline") { _ in
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }, animated: true)
            }
            
        }
        
    }
    
    func createPin() {
        guard let context = coordinator?.dataStore.viewContext else { return }
        pin = Pin(context: context)
        pin.id = annotation.id
        pin.latitude = annotation.coordinate.latitude
        pin.longitude = annotation.coordinate.longitude
    }
    
    func createCurrentWeather() {
        guard let context = coordinator?.dataStore.viewContext else { return }
        currentWeather = CurrentWeather(context: context)
        currentWeather.id = UUID().uuidString
        currentWeather.createdAt = Date()
        currentWeather.pinID = pin.id
        currentWeather.city = annotation.title
        currentWeather.prepare(toSave: weather)
        
        guard let image = imageView.image else {return}
        currentWeather.icon = image.pngData()
        
    }
    
    func deleteSavedWeather(_ id: String) {
        let alert = Alert.show(.weatherDeletion) { _ in
            self.coordinator?.dataStore.delete(CurrentWeather.self, with: id) { completed in
                DispatchQueue.main.async {
                    if completed {
                        self.navigationController?.popToRootViewController(animated: true)
                    } else {
                        self.present(Alert.show(.general),animated: true)
                    }
                }
            }
        }
        self.present(alert, animated: true)
    }
    
    @IBAction func btnActionPressed(_ sender: Any) {
        
        if let id = id {
            
            deleteSavedWeather(id)
            
        } else {
            
            createCurrentWeather()
            
            do {
                try coordinator?.dataStore.viewContext.save()
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                DispatchQueue.main.async {
                    self.present(Alert.show(.saveError),animated:true)
                }
            }
            
        }
    }
    
    @IBAction func useMapButtonPressed(_ sender: Any) {
        coordinator?.showMapView()
    }
    
}

extension WeatherViewController: WeatherListViewModelDelegate {
    
    func onPreloader(_ isLoading: Bool) {
        self.configureUI(isLoading)
    }
    
    func onDataFailed() {
        self.present(Alert.show(.general), animated: true)
    }
    
    func onWeatherSuccess(_ response: Weather) {
        let weather = response.weather[0]
        let main = response.main
        self.weather = response
        imageView.download(from: WeatherClient.get(weather.icon))
        txtCity.text = annotation.title
        txtWeatherDescription.text = weather.desc
        txtTemperature.text = main.temp.celsius()
        txtHumidity.text = "HUMIDITY \(main.humidity)%"
    }
    
    func onWeatherFailure() {
        self.present(Alert.show(.server), animated: true)
    }
    
    func onWeatherError(weatherError: WeatherError) {
        let alert = Alert.show(.weatherDeletion, message: weatherError.message)
        self.present(alert, animated: true, completion: nil)
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
    
    func configure(with weather: CurrentWeather ) {
        txtCity.text = weather.city
        txtWeatherDescription.text = weather.subtitle
        txtTemperature.text = weather.temperature.celsius()
        txtHumidity.text = "HUMIDITY \(weather.humidity!)%"
        
        guard let icon = weather.icon else { return }
        imageView.image = UIImage(data: icon)
    }
    
}
