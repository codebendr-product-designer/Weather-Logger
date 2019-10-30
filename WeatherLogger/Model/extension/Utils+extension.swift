//
//  Double+extension.swift
//  WeatherLogger
//
//  Created by codebendr on 29/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

extension Double {
    func celsius() -> String {
       // return (self - 273.15).rounded()
       return "\(String(format:"%g",(self - 273.15).rounded()))°"
    }
}

