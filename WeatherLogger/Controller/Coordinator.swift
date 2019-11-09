//
//  Coordinator.swift
//  WeatherLogger
//
//  Created by codebendr on 09/11/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
