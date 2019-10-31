//
//  Alert.swift
//  WeatherLogger
//
//  Created by codebendr on 29/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

import UIKit

struct Alert {
    
    enum AlertType {
        case general
        case server
        case pinDeletion
        case weatherDeletion
        case weather
        case saveError
        case locationError
        case location
    }
    
    private static func localized(_ type: AlertType) -> (title: String, message: String) {
        switch type {
        case .general :
            return (title: "Unknown Error", message: "An unknown error occured")
        case .server :
            return (title: "Server Error", message: "Server returned an error")
        case .pinDeletion :
            return (title: "Delete Pin", message: "Are you sure you want to delete this pin")
        case .weatherDeletion :
            return (title: "Delete Weather", message: "Are you show you want to delete this")
        case .saveError :
            return (title: "Save Error", message: "Saving did not work")
        case .locationError :
            return (title: "Location Services disabled", message: "Please use + button to add weather logs")
        case .location :
            return (title: "Location Services ", message: "Please use + button to add weather logs")
        case .weather :
            return (title: "Weather Services ", message: "Please use + button to add weather logs")
        }
    }
    
    static func show(_ type: AlertType, message: String = "", handler: @escaping (UIAlertAction) -> Void = { _ in return }) -> UIAlertController {
        let localMessage = message.count != 0 ? message : Alert.localized(type).message
        let alert = UIAlertController(title: Alert.localized(type).title, message: localMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: handler))
        return alert
    }
    
    static func show(_ type: AlertType, handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: Alert.localized(type).title, message: Alert.localized(type).message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: handler))
        return alert
    }
    
}
