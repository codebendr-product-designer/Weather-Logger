//
//  Section.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation

struct Section<U: Hashable, T: Hashable>: Hashable {
    let title: U
    let items: T
}
