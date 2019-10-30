//
//  WeatherCell.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView, DefaultCell {
    static var reuseIdentifier: String = "SectionHeader"
    
    let city = UILabel()
    let temperature = UILabel()
    let humidity = UILabel()
    let desc = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.systemTeal
        layer.borderWidth = 0.8
        layer.cornerRadius = 14
        
                print("SectionHeader")
        
        temperature.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        temperature.textColor = .white
        
        city.font = UIFont.preferredFont(forTextStyle: .title2)
        city.textColor = .white
        
        desc.font = UIFont.preferredFont(forTextStyle: .subheadline)
        desc.textColor = .white
        
        humidity.font = UIFont.preferredFont(forTextStyle: .subheadline)
        humidity.textColor = .white

        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        temperature.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let hStack = UIStackView(arrangedSubviews: [city, desc, temperature, humidity])
        
        let vStack = UIStackView(arrangedSubviews: [hStack, imageView])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.spacing = 16
        
        addSubview(vStack)
        
        let spacing: CGFloat = 16
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: spacing),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: spacing),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: spacing)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with weather: CurrentWeather) {
        print("CONFIGURE")
        city.text = weather.city
        desc.text = weather.subtitle
        humidity.text = weather.humidity
        temperature.text = weather.temperature.celsius()
        
        guard let icon = weather.icon else { return }
        imageView.image = UIImage(data: icon)
        
    }
    
}
