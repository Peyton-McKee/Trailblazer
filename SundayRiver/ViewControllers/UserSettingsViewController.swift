//
//  UserSettingsViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/10/22.
//

import Foundation
import UIKit

class UserSettingsViewController : UIViewController {
    var logOutButton = UIButton()
    var userNameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureLabels()
    }
    
    private func configureButtons()
    {
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.setTitleColor(.blue, for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        view.addSubview(logOutButton)
        createConstraints(item: logOutButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 10)
    }
    
    private func configureLabels()
    {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 20)
        userNameLabel.text = "Username: \(InteractiveMapViewController.currentUser.userName)"
        view.addSubview(userNameLabel)
        createConstraints(item: userNameLabel, distFromLeft: 0, distFromTop: Double(view.bounds.height)/10)
    }
    @objc func logOutPressed(sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
    func createConstraints(item: UIView, distFromLeft: Double, distFromTop: Double)
    {
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: distFromTop),
            item.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: distFromLeft),
            item.heightAnchor.constraint(equalToConstant: 40),
            item.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
            ])
    }
}