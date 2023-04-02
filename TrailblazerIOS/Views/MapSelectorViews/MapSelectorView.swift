//
//  MapSelectorView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/13/23.
//

import Foundation
import UIKit

final class MapSelectorView : UIView {
    var maps: [MapPreview] = []
    
    lazy var collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        return collectionView
    }()
    
    weak var vc: MapSelectorViewController?
    
    init(vc: MapSelectorViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        self.addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayOptions(maps: [MapPreview]) {
        self.maps = maps
        self.collectionView.reloadData()
    }
}
