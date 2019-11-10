//
//  StoryboardController.swift
//  WeatherLogger
//
//  Created by codebendr on 09/11/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit

protocol StoryboardController {
    static func instantiate() -> Self
}

extension StoryboardController where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
