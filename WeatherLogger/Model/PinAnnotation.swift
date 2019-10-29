//
//  PinAnnotation.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import MapKit
import Foundation

class PinAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var id = UUID().uuidString
    var title: String?
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
