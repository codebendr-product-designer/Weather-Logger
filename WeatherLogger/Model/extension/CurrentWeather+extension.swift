//
//  CurrentWeather+extension.swift
//  WeatherLogger
//
//  Created by codebendr on 29/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation
import CoreData

extension CurrentWeather {
    
    func prepare(toSave response: Weather){
        let weather = response.weather[0]
        let main = response.main
        self.title = weather.main
        self.subtitle = weather.desc
        self.temperature = main.temp
        self.humidity = "\(main.humidity)"
    }
    
    func fetch(_ result: @escaping ([CurrentWeather]?) -> Void) {
        let fetchRequest: NSFetchRequest<CurrentWeather> = CurrentWeather.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        guard let context = self.managedObjectContext else {
            result(nil)
            return
        }
        
        do {
            let currentWeatherList = try context.fetch(fetchRequest)
            result(currentWeatherList)
        } catch {
            result(nil)
        }
    }
    
    func delete(with id: String, _ completed: (Bool) -> Void) {
        
        let fetchRequest: NSFetchRequest<CurrentWeather> = CurrentWeather.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        guard let context = self.managedObjectContext else {
            completed(false)
            return
        }
        
        do {
            let currentWeatherList = try context.fetch(fetchRequest)
            for currentWeather in currentWeatherList {
                context.delete(currentWeather)
            }
            completed(true)
            try context.save()
            
        } catch {
            completed(false)
        }
    }
}
