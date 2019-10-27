//
//  Results.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//


import Foundation

struct Results {
    var data: Data?
    var response: Response?
    var error: Error?
    
    init(with data: Data?, response: Response?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    init(withError error: Error) {
        self.error = error
    }
}

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
    case weatherError(WeatherError)
}

