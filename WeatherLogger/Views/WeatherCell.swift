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
    
    let city = UILabel()
    let temperature = UILabel()
    let desc = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        temperature.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        city.font = UIFont.preferredFont(forTextStyle: .headline)
        city.textColor = .purple
        
        desc.font = UIFont.preferredFont(forTextStyle: .subheadline)
        desc.textColor = .purple
        
        temperature.textColor = .purple
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.purple.cgColor
        contentView.layer.cornerRadius = 14
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        temperature.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let vStack = UIStackView(arrangedSubviews: [city, desc])
        vStack.axis = .vertical
        let hStack = UIStackView(arrangedSubviews: [temperature, vStack])
        hStack.spacing = 16
        
        let hStackMain = UIStackView(arrangedSubviews: [hStack, imageView])
        hStackMain.translatesAutoresizingMaskIntoConstraints = false
        hStackMain.alignment = .center
        hStackMain.spacing = 78
        contentView.addSubview(hStackMain)
        
        NSLayoutConstraint.activate([
            hStackMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStackMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStackMain.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStackMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with weather: CurrentWeather) {
        
        city.text = weather.city
        desc.text = weather.subtitle
        temperature.text = weather.temperature.celsius()
        
        guard let icon = weather.icon else { return }
        imageView.image = UIImage(data: icon)
        
        
    }
    
}
