//
//  UIImageView+extension.swift
//  WeatherLogger
//
//  Created by codebendr on 27/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func download(from url: String, completed: @escaping (UIImage?) -> Void = { _ in return }) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
            completed(image)
        }).resume()
    }
}
