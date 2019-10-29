//
//  WeatherCell.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell, DefaultCell {

    static var reuseIdentifier: String = "WeatherCell"
    
    let temperature = UILabel()
    let title = UILabel()
    let subtitle = UILabel()
    let temperatureView = UIView()
    
    override init(frame: CGRect) {
         super.init(frame: frame)
        
        
        
    }
  
    func configure(with model: CurrentWeather) {
         
     }

}
