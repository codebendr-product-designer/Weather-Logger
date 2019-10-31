//
//  WeatherClient.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//
import Foundation
import MapKit

enum EndPoint: String {
    case weather
    func get() -> (url:URL?, restManager: RestManager?) {
        
        let restManager = RestManager()
        
        //defualt methods for API
        restManager.parameters.add(value: "b6907d289e10d714a6e88b30761fae22", forKey: "appid")
        restManager.parameters.add(value: "b5356aff41df4453fbb4cd26d2e817fc", forKey: "apiKey")
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/\(self.rawValue)/")
        return (url, restManager)
    }
}

class WeatherClient {
    static func decode<T:Codable>(_ object: T.Type,data: Data, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let decodedResponse =  try JSONDecoder().decode(T.self, from: data)
            completion(Result.success(decodedResponse))
        } catch let error {
            if let decodedError = try? JSONDecoder().decode(WeatherError.self, from: data) {
                completion(Result.weatherError(decodedError))
            } else {
                completion(Result.failure(error))
            }
        }
    }
    static func get(_ icon: String) -> String {
        return "https://openweathermap.org/img/w/\(icon).png"
    }
    
    static func load(with coordinate: CLLocationCoordinate2D, completion: (Results)) {
        
    }
}
