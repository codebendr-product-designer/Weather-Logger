//
//  ViewController.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    let locationManager = CLLocationManager()
    var dataStore: DataStore!
    var isLocation = false
    let locationStatus = CLLocationManager.authorizationStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                stackView.isHidden = false
            case .authorizedAlways, .authorizedWhenInUse:
                stackView.isHidden = true
            default :
                return
            }
        }
    }
    
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
    
    @IBAction func enableLocationButtonPressed(_ sender: Any) {
        
        
        
        switch locationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
            
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location Services disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            stackView.isHidden = true
            break
        default:
            return
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isLocation {
            
            isLocation = true
            
            if let currentLocation = locations.last {
                
                let weatherViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
                
                let annotation = PinAnnotation(coordinate: currentLocation.coordinate)
                
                let lon = currentLocation.coordinate.longitude
                let lat = currentLocation.coordinate.latitude
                find(location: CLLocation(latitude: lat, longitude: lon)) {
                    placemark in
                    if let placemark = placemark {
                        annotation.title = placemark.locality
                    }
                    
                    weatherViewController.annotation = annotation
                    weatherViewController.dataStore = self.dataStore
                    
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(weatherViewController, animated: true)
                    }
                    
                }
                
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}



