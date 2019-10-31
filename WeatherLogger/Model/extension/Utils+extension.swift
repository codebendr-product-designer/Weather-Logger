//
//  Double+extension.swift
//  WeatherLogger
//
//  Created by codebendr on 29/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func celsius() -> String {
       return "\(String(format:"%g",(self - 273.15).rounded()))°"
    }
}

struct Basic {
    
    // A delay function
    public static func delay(seconds: Double, completion: @escaping ()-> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
}

