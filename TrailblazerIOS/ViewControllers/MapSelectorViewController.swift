//
//  MapSelector.swift
//  Trailblazer
//
//  Created by Peyton McKee on 1/27/23.
//

import Foundation
import UIKit

class MapSelectorViewController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    var maps: [Map] = []
    
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        view.addSubview(collectionView)
        
        getMaps(completion: {
            result in
            guard let maps = try? result.get() else {
                print("error: \(result)")
                return
            }
            print("received maps: \(maps)")
            self.maps = maps
            self.collectionView.reloadData()
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CustomCollectionViewCell
        cell.backgroundColor = .blue
        if let name = maps[indexPath.row].name{
            cell.label.text = name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = maps[indexPath.row].id {
            if(!(id == InteractiveMapViewController.mapId)){
                InteractiveMapViewController.mapId = id
                UserDefaults.standard.set(id, forKey: "mapId")
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
    }
    
}
