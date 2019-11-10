//
//  ViewController.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import CoreLocation

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var dataStore:DataStore!
    
    init(navigationController: UINavigationController, dataStore: DataStore) {
        self.navigationController = navigationController
        self.dataStore = dataStore
    }
    
    func start() {
        let mainViewController = MainViewController.instantiate()
        mainViewController.coordinator = self
        self.navigationController.pushViewController(mainViewController, animated: false)
    }
    
    func showWeatherView(_ annotation: PinAnnotation?, configure: (WeatherViewController) -> () = { _ in return }) {
        let vc = WeatherViewController.instantiate()
        vc.coordinator = self
        vc.annotation = annotation
        configure(vc)
        DispatchQueue.main.async {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
    
    func showMapView() {
        let vc = MapViewController.instantiate()
        vc.coordinator = self
        DispatchQueue.main.async {
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}

class MainViewController: UIViewController, StoryboardController {
    
    var collectionView: UICollectionView!
    let locationManager = CLLocationManager()
    //   var dataStore: DataStore!
    let locationStatus = CLLocationManager.authorizationStatus()
    var currentWeatherList = [CurrentWeather]()
    var dataSource: UICollectionViewDiffableDataSource<Section, CurrentWeather>?
    
    var sectionHeader: SectionHeader?
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatCollectionView()
        
        locationManager.delegate = self
        
        isLocationEnabled()
        
        createDataSource()
        createHeaderDataSource()
        
        self.edgesForExtendedLayout = .bottom
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator?.dataStore.fetch(CurrentWeather.self){
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
            coordinator?.showMapView()
            
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
            coordinator?.showWeatherView(annotation)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinator?.showMapView()
    }
    
}
