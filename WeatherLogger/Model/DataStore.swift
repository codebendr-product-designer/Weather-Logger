//
//  DataStore.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation
import CoreData

class DataStore {
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func fetch<T: NSManagedObject>(_ object: T.Type ,_ result: @escaping ([Any]?) -> Void) {
        guard let fetchRequest = T.fetchRequest()  as? NSFetchRequest<T> else {
            fatalError("fetch error - crash app")
        }
        //created at is specific to this application
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let list = try viewContext.fetch(fetchRequest)
            result(list)
        } catch {
            result(nil)
        }
    }
    
    func delete<T: NSManagedObject>(_ object: T.Type, with id: String, _ completed: (Bool) -> Void) {
        
        guard let fetchRequest = T.fetchRequest()  as? NSFetchRequest<T> else {
            fatalError("fetch error - crash app")
        }
        
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        do {
            let currentWeatherList = try viewContext.fetch(fetchRequest)
            for currentWeather in currentWeatherList {
                viewContext.delete(currentWeather)
            }
            completed(true)
            try viewContext.save()
            
        } catch {
            completed(false)
        }
    }
    
    
}

extension DataStore {
    func autoSave(interval: TimeInterval = 30) {
        guard interval > 0 else {
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSave(interval: interval)
        }
    }
}

