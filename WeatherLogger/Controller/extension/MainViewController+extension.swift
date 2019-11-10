//
//  MainViewController+extension.swift
//  WeatherLogger
//
//  Created by codebendr on 31/10/2019.
//  Copyright © 2019 just pixel. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MainViewController {
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CurrentWeather>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(currentWeatherList)
        
        if let sectionHeader = self.sectionHeader {
            sectionHeader.configure(with: currentWeatherList.last)
        }
  
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
            self.sectionHeader = sectionHeader
            return sectionHeader
            
        }
    }
    
    func creatCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositonalLayout())
        collectionView.delegate = self
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.reuseIdentifier)
        
        view.addSubview(collectionView)
    }
    
}

extension MainViewController {
    
//    func loadWeatherViewController(annotation: PinAnnotation) {
//
//
//        let weatherViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
//
//        weatherViewController.annotation = annotation
//        self.navigationController?.pushViewController(weatherViewController, animated: true)
//        
//
//    }
//
//    func loadMapViewController() {
//
//        let mapViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//
//        mapViewController.dataStore = self.dataStore
//
//        self.navigationController?.pushViewController(mapViewController, animated: true)
//
//
//    }
}



extension MainViewController {
    
    func createCompositonalLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.43))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 5, bottom: 4, trailing: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.55))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.interGroupSpacing = 5
       // layoutSection.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let layoutSectionHeader = createSectionHeader()
        layoutSection.boundarySupplementaryItems  = [layoutSectionHeader]
        
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
        
        let weatherViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        
        weatherViewController.id = self.currentWeatherList[indexPath.row].id
        self.navigationController?.pushViewController(weatherViewController, animated: true)
        
    }
}
