//
//  ViewController.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func loadPhotAlbum(coordinate: CLLocationCoordinate2D)  {
        
        
        let restManager = RestManager()
        if let url = EndPoint.rest.get().url {
            
            let random = Int.random(in: 1...pages)
            
            restManager.parameters.add(value: "\(coordinate.latitude)", forKey: "lat")
            restManager.parameters.add(value: "\(coordinate.longitude)", forKey: "lon")

            
            DispatchQueue.main.async {
            }
            
            restManager.request(url: url, with: .get) {
                results in
                
                if results.error == nil {
                    
                    DispatchQueue.main.async {
                       
                    }
                    
                    guard let data = results.data else {
                        DispatchQueue.main.async {
                           
                        }
                        return
                    }
                    
                    WeatherClient<FlickrStat>().decode(data: data) {
                        result in
                        
                        switch result {
                            
                        case .success(let response):
                            if !response.photos.photo.isEmpty {
                                self.setupPhotos(response.photos)
                                self.pages = response.photos.pages
                            } else {
                                DispatchQueue.main.async {
                                    let alert = Alert.show(type: .noPhotos, message: "Please try another location on the map") { _ in
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    self.present(alert, animated: true)
                                }
                            }
                            
                        case .failure(_):
                            DispatchQueue.main.async {
                                self.present(Alert.show(type: .server), animated: true)
                            }
                            
                        case .flickrError(let flickrError):
                            DispatchQueue.main.async {
                                let alert = Alert.show(type: .photosError, message: flickrError.message)
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                        
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.present(Alert.show(type: .general), animated: true)
                    }
                }
            }
        }
    }


}

