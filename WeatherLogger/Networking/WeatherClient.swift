//
//  WeatherClient.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//
//b5356aff41df4453fbb4cd26d2e817fc
//icon link - https://openweathermap.org/img/w/10n.png
import Foundation

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

struct WeatherPhotoURL {
    static func get(_ icon: String) -> String {
          return "https://openweathermap.org/img/w/\(icon).png"
      }
}

class WeatherClient<T:Codable>{
    func decode(data: Data, completion: @escaping (Result<T, Error>) -> Void) {
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
}
