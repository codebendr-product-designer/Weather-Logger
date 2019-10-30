//
//  WeatherCell.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static var reuseIdentifier: String = "SectionHeader"
    
    let city = UILabel()
    let temperature = UILabel()
    let humidity = UILabel()
    let desc = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let teal = UIColor.systemTeal
        temperature.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        city.font = UIFont.preferredFont(forTextStyle: .title2)
        //city.textColor = teal
        
        desc.font = UIFont.preferredFont(forTextStyle: .subheadline)
        // desc.textColor = teal
        
        temperature.textColor = teal
        
        layer.borderWidth = 0.8
        layer.borderColor = teal.cgColor
        layer.cornerRadius = 14
        
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
        
//        NSLayoutConstraint.activate([
//            hStackMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
//            hStackMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            hStackMain.topAnchor.constraint(equalTo: contentView.topAnchor),
//            hStackMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
