//
//  ViewController.swift
//  WeatherLogger
//
//  Created by codebendr on 26/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    
    var collectionView: UICollectionView!
    let locationManager = CLLocationManager()
    var dataStore: DataStore!
    var isLocation = false
    var isMap = false
    let locationStatus = CLLocationManager.authorizationStatus()
    var currentWeatherList = [CurrentWeather]()
    var dataSource: UICollectionViewDiffableDataSource<Section, CurrentWeather>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         creatCollectionView()
        
        locationManager.delegate = self
        
        isLocationEnabled()
  
        createDataSource()
      //  createHeaderDataSource()
        
        self.edgesForExtendedLayout = .bottom
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataStore.fetch(CurrentWeather.self){
            weatherList in
            guard let weatherList = weatherList as? [CurrentWeather] else { return }
            self.currentWeatherList = weatherList
            self.reloadData()
        }
    }
    
    @IBAction func addLocationButtonPressed(_ sender: Any) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                loadMapViewController()
                return
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                isLocation = false
            default :
                return
            }
        }
    }
    
    func isLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                configureUI(true)
            case .authorizedAlways, .authorizedWhenInUse:
                configureUI(false)
            default :
                return
            }
        }
    }
    
    @IBAction func enableLocationButtonPressed(_ sender: Any) {
        
        switch locationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            stackView.isHidden = false
            present(Alert.show(.locationError), animated: true)
            return
        case .authorizedAlways, .authorizedWhenInUse:
            configureUI(false)
            break
        default:
            return
        }
        
        locationManager.startUpdatingLocation()
        
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isLocation {
            
            isLocation = true
            
            if let currentLocation = locations.last {
                
                let annotation = PinAnnotation(coordinate: currentLocation.coordinate)
                
                let lon = currentLocation.coordinate.longitude
                let lat = currentLocation.coordinate.latitude
                
                loadWeatherViewController(CLLocation(latitude: lat, longitude: lon), annotation: annotation)
                
                locationManager.stopUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

extension MainViewController {
    
    func loadWeatherViewController(_ location: CLLocation, annotation: PinAnnotation) {
        
        let weatherViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        
        weatherViewController.annotation = annotation
        weatherViewController.dataStore = self.dataStore
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(weatherViewController, animated: true)
        }
        
    }
    
    func loadMapViewController() {
        
        let mapViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        // mapViewController.annotation = annotation
        mapViewController.dataStore = self.dataStore
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
        
    }
}

extension MainViewController {
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeather>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(currentWeatherList)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func configure<T: DefaultCell>(_ cellType: T.Type, with weather: CurrentWeather, for indexPath: IndexPath) -> T {
        guard let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to dequeue \(cellType)")
        }
        cell.configure(with: weather)
        return cell
    }
    
    func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section,CurrentWeather>(collectionView: collectionView) {
            collectionView, indexPath, weather in
            return self.configure(WeatherCell.self, with: weather, for: indexPath)
        }
    }
    
    func createHeaderDataSource() {
        dataSource?.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader else {
                fatalError("Cannot create new header")
            }
            
            sectionHeader.configure(with: self.currentWeatherList.last)
            sectionHeader.setNeedsLayout()
            return sectionHeader
            
        }
    }
    
    func creatCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositonalLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
//        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.reuseIdentifier)
        
        view.addSubview(collectionView)
    }
    
}

extension MainViewController {
    
    func configureUI(_ showStackView: Bool) {
        stackView.isHidden = !showStackView
        collectionView.isHidden = showStackView
    }
    
    func createCompositonalLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.43))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 5, bottom: 4, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.55))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 5
        //layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
//        let layoutSectionHeader = createSectionHeader()
//        layoutSection.boundarySupplementaryItems  = [layoutSectionHeader]
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(section: layoutSection)
        layout.configuration = config
        return layout
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.22))
        
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        layoutSectionHeader.pinToVisibleBounds = true
        return layoutSectionHeader
        
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
