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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    @IBAction func enableLocationButtonPressed(_ sender: Any) {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
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
        if let currentLocation = locations.last {
            
            let weatherViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            
            weatherViewController.annotation = PinAnnotation(coordinate: currentLocation.coordinate)
            weatherViewController.dataStore = dataStore
            
            self.navigationController?.pushViewController(weatherViewController, animated: true)

            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}



