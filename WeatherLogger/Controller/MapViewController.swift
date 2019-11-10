//
//  ViewController.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, StoryboardController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataStore: DataStore!
    var annotation:PinAnnotation!
    let regionRadius: CLLocationDistance = 1000000
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        mapLongPressGesture()
    }
    
}

extension MapViewController {
    
    func setupMap() {
        let initialLocation: CLLocation = CLLocation(latitude: 37, longitude: -122)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: UILongPressGestureRecognizer
    func mapLongPressGesture() {
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer) {
        
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        DispatchQueue.main.async {
            let annotation = PinAnnotation(coordinate: touchMapCoordinate)
            self.mapView.addAnnotation(annotation)
            
          //  let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            
            Basic.delay(seconds: 1.5) {
                //self.loadWeatherViewController(annotation: annotation)
                self.coordinator?.showWeatherView(annotation)
                self.mapView.removeAnnotation(annotation)
            }
        }
        
    }
    
}

extension MapViewController {
    
//    func loadWeatherViewController(annotation: PinAnnotation) {
//
//        let weatherViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
//
//        weatherViewController.annotation = annotation
//        weatherViewController.dataStore = self.dataStore
//
//        DispatchQueue.main.async {
//            self.navigationController?.pushViewController(weatherViewController, animated: true)
//        }
//
//    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView!.leftCalloutAccessoryView = UIButton(type: .close)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
}

