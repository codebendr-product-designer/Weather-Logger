//
//  WeatherCell.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import SnapKit

class SectionHeader: UICollectionReusableView {
    static var reuseIdentifier: String = "SectionHeader"
    
    let city = UILabel()
    let temperature = UILabel()
    let humidity = UILabel()
    let desc = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.systemTeal
        layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2);
        
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
        
        imageView.sizeThatFits(.init(width: 60, height: 60))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        let hStack = UIStackView(arrangedSubviews: [city, desc, temperature, humidity])
        hStack.axis = .vertical
        
        let vStack = UIStackView(arrangedSubviews: [hStack, imageView])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.alignment = .center
        vStack.spacing = 60
        
        addSubview(vStack)
        
        let spacing: CGFloat = 16
        
//        NSLayoutConstraint.activate([
//            vStack.leadingAnchor.constraint(equalTo: leadingAnchor,constant: spacing),
//            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: spacing),
//            vStack.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
//            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: spacing)
//        ])
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reset() {
        let empty = ""
        city.text  = empty
        desc.text = empty
        humidity.text = empty
        temperature.text = empty
    }
    
    func configure(with weather: CurrentWeather?) {
        if let weather = weather {
            city.text = weather.city
            desc.text = weather.subtitle
            humidity.text = "HUMIDITY \(weather.humidity!)%"
            temperature.text = weather.temperature.celsius()
            
            guard let icon = weather.icon else { return }
            imageView.image = UIImage(data: icon)
        } else {
            reset()
        }
    }
 
}
