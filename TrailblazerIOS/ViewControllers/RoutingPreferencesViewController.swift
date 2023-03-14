//
//  RoutingPreferencesViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 12/3/22.
//

import Foundation
import UIKit

class RoutingPreferencesViewController: UIViewController {
    lazy var routingPreferencesView = RoutingPreferencesView(vc: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(routingPreferencesView)
    }
   
    func setPreference(type: RoutingType) {
        InteractiveMapViewController.currentUser.routingPreference = type.rawValue
        UserDefaults.standard.set(type.rawValue, forKey: "routingPreference")
        APIHandler.shared.updateUser(InteractiveMapViewController.currentUser)
        var preference = MapInterpreter.shared.distanceGraph
        switch type{
        case RoutingType.easiest:
            preference = MapInterpreter.shared.difficultyGraph
        case RoutingType.quickest:
            preference = MapInterpreter.shared.timeGraph
        default:
            break
        }
        NotificationCenter.default.post(name: Notification.Name("updateRoutingPreference"), object: nil, userInfo: ["preference": preference])
    }
}
