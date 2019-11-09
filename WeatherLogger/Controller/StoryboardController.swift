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
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
