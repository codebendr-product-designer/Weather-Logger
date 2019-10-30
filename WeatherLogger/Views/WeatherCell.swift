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
        
        city.font = UIFont.preferredFont(forTextStyle: .headline)
        city.textColor = .label
        
        desc.font = UIFont.preferredFont(forTextStyle: .subheadline)
        desc.textColor = .secondaryLabel
        
        let innerStackView = UIStackView(arrangedSubviews: [city, desc])
        innerStackView.axis = .vertical
        
        let outerStackView = UIStackView(arrangedSubviews: [temperature,innerStackView, imageView])
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.alignment = .center
        outerStackView.spacing = 10
        contentView.addSubview(outerStackView)
        
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with weather: CurrentWeather) {
        
        city.text = weather.city
        desc.text = weather.description
        temperature.text = "\(weather.temperature)"
        
        guard let icon = weather.icon else { return }
        imageView.image = UIImage(data: icon)
        
        
    }
    
}
