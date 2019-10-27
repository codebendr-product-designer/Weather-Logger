//
//  UIStoryboard+extension.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit

struct Storyboard {
    static let main = "Main"
}

extension UIStoryboard {
    @nonobjc class var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}

