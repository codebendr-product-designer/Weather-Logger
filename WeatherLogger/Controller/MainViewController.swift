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
    
    var collectionView: UICollectionView!
    let locationManager = CLLocationManager()
    var dataStore: DataStore!
    let locationStatus = CLLocationManager.authorizationStatus()
    var currentWeatherList = [CurrentWeather]()
    var dataSource: UICollectionViewDiffableDataSource<Section, CurrentWeather>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatCollectionView()
        
        locationManager.delegate = self
        
        isLocationEnabled()
        
        createDataSource()
        //createHeaderDataSource()
        
        self.edgesForExtendedLayout = .bottom
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataStore.fetch(CurrentWeather.self){
            weatherList in
            guard let weatherList = weatherList as? [CurrentWeather] else { return }
            self.currentWeatherList = weatherList
            self.reloadData()
        }
    }
    
}

extension MainViewController {
    
    @IBAction func addLocationButtonPressed(_ sender: Any) {
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        switch locationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            loadMapViewController()
            
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        default:
            return
        }
    }
    
    func isLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                present(Alert.show(.location), animated: true)
            case .restricted, .denied:
                present(Alert.show(.locationError), animated: true)
            case .authorizedAlways, .authorizedWhenInUse:
                return
            default :
                return
            }
        } else {
            present(Alert.show(.location), animated: true)
        }
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        if let currentLocation = locations.last {
            
            
            let annotation = PinAnnotation(coordinate: currentLocation.coordinate)
            
            let lon = currentLocation.coordinate.longitude
            let lat = currentLocation.coordinate.latitude
            
            loadWeatherViewController(CLLocation(latitude: lat, longitude: lon), annotation: annotation)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        loadMapViewController()
    }
    
}


