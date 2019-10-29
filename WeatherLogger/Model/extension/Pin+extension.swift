//
//  Pin+extension.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation
import CoreData

extension Pin {
    func fetch(dataStore: DataStore, result: @escaping ([Pin]?) -> Void) {
        let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let pins = try dataStore.viewContext.fetch(fetchRequest)
            result(pins)
        } catch {
            result(nil)
        }
    }
}
