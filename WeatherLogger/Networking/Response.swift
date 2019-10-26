//
//  Response.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//


import Foundation

struct Response {
    
    var response: URLResponse?
    var httpStatusCode: Int = 0
    var headers = Rest()
    
    init(url response: URLResponse?) {
        guard let response = response else { return }
        self.response = response
        httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        
        if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
            for (key, value) in headerFields {
                headers.add(value: "\(value)", forKey: "\(key)")
            }
        }
    }
    
}

