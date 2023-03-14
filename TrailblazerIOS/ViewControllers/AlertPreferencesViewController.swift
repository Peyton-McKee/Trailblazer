//
//  AlertPreferencesViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 12/3/22.
//

import Foundation
import UIKit

class AlertPreferencesViewController: UIViewController {
    lazy var alertPreferencesView = AlertPreferencesView(vc: self)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.addSubview(alertPreferencesView)
    }
    
    @objc func toggleSwitch(sender: UISwitch)
    {
        guard let type = sender.userActivity?.userInfo?["type"] as? String else {
            print("Incorrect user info configuration")
            return
        }
        
        if sender.isOn
        {
            InteractiveMapViewController.currentUser.alertSettings.append(type)
            for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == type}){
                NotificationCenter.default.post(name: Notification.Name.Names.createNotification, object: nil, userInfo: ["report": trailReport])
            }
        }
        else
        {
            InteractiveMapViewController.currentUser.alertSettings.removeAll(where: { $0 == type})
            LocationManager.shared.unregesterNotification(for: type)
        }
        
        UserDefaults.standard.set(InteractiveMapViewController.currentUser.alertSettings, forKey: "alertSettings")
        APIHandler.shared.updateUser(InteractiveMapViewController.currentUser)
    }
}
