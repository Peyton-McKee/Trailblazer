//
//  TabBarViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/9/22.
//

import Foundation
import UIKit

class TabBarViewController : UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.present(InteractiveMapViewController(), animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabOne = InteractiveMapViewController()
        let tabOneBarItem = UITabBarItem(title: "Map", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        tabOne.tabBarItem = tabOneBarItem
        let tabTwo = TrailSelectorViewController()
        let tabTwoBarItem = UITabBarItem(title: "Trails", image: UIImage(named: "defaultImage.png"), selectedImage: UIImage(named: "selectedImage.png"))
        tabTwo.tabBarItem = tabTwoBarItem
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tabBarController.show(viewController, sender: self)
    }
}
