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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var dataStore: DataStore!
    var annotations = [PinAnnotation]()
    let regionRadius: CLLocationDistance = 1000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setupMap()
        
        mapLongPressGesture()
        fetchPins()
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
        longPressRecogniser.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecogniser)
    }
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer) {
        
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
    }
    
    func fetchPins () {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            setupPins(pins: try dataStore.viewContext.fetch(fetchRequest))
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func setupPins(pins: [Pin]) {
        annotations = pins.map { pin in
            let lat = CLLocationDegrees(pin.latitude)
            let long = CLLocationDegrees(pin.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let pinAnnotation = PinAnnotation(coordinate: coordinate)
            pinAnnotation.title = "View Photos"
            pinAnnotation.id = pin.id!
            return pinAnnotation
        }
        self.mapView.addAnnotations(annotations)
    }
    
    
}

