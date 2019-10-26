//
//  Rest.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//


import Foundation

struct Rest {
    
    private var values = [String: Any]()
    
    mutating func add(value: String, forKey key: String) {
        values[key] = value
    }

    mutating func add(values: [String: Any], forKey key: String) {
        self.values[key] = values
    }
    
    mutating func add(values: [String: Any]) {
        self.values = values
    }
    
    func value(forKey key: String) -> String? {
        return values[key] as? String
    }
    
    func allValues() -> [String: Any] {
        return values
    }
    
    func totalItems() -> Int {
        return values.count
    }
    
    
}

