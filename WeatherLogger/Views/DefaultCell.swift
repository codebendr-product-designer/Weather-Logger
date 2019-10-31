//
//  DefaultCell.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

enum Section: CaseIterable {
    case main
}

protocol DefaultCell {
    static var reuseIdentifier: String { get }
    func configure(with model: CurrentWeather)
}
