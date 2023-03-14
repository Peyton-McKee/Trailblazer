//
//  MapSelector.swift
//  Trailblazer
//
//  Created by Peyton McKee on 1/27/23.
//

import Foundation
import UIKit

class MapSelectorViewController : UIViewController {
    
    lazy var mapSelectorView = MapSelectorView(vc: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mapSelectorView)
        
        APIHandler.shared.getMaps(completion: {
            result in
            guard let maps = try? result.get() else {
                print("error: \(result)")
                return
            }
            print("received maps: \(maps)")
            self.mapSelectorView.displayOptions(maps: maps)
        })
        
    }
    
    func switchRootViewController(id: String) {
        if(!(id == InteractiveMapViewController.mapId)){
            InteractiveMapViewController.mapId = id
            UserDefaults.standard.set(id, forKey: "mapId")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
}
