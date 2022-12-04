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
    var backgroundImageView = UIImageView()
    var dimmedBackground = UIView()
    var settingsTableView = UITableView()
    var options: [Setting] = [Setting(name: "Trail Reports Made", image: UIImage(systemName: "snowflake")!, textColor: .green, viewController: UserTrailReportsViewController()),  Setting(name: "Alert Preferences", image: UIImage(systemName: "bell.badge")!, textColor: .blue, viewController: AlertPreferencesViewController()), Setting(name: "Preferred Routing", image: UIImage(systemName: "figure.hiking")!, textColor: .blue, viewController: RoutingPreferencesViewController()), Setting(name: "More Settings", image: UIImage(systemName: "circle")!, textColor: .red, viewController: UserTrailReportsViewController())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        backgroundImageView.image = UIImage(named: "SRMoon.png")!
        backgroundImageView.frame = view.frame
        view.addSubview(backgroundImageView)
        configureTableView()
        configureButtons()
        configureLabels()
    }
    private func configureTableView()
    {
        dimmedBackground.backgroundColor = UIColor(hex: "#000000A0")
        view.addSubview(dimmedBackground)
        dimmedBackground.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        settingsTableView.layer.cornerRadius = 15
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.frame = CGRect(x: 20, y: view.bounds.height/5, width: view.bounds.width - 40, height: view.bounds.height - view.bounds.height/5)
        settingsTableView.backgroundColor = UIColor(hex: "#00000000")
        settingsTableView.register(UserSettingsTableViewCell.self, forCellReuseIdentifier: "userSettingsCell")
        view.addSubview(settingsTableView)
        
    }
    private func configureButtons()
    {
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.titleLabel?.font = UIFont(name: "markerfelt-wide", size: 20)
        logOutButton.setTitleColor(.blue, for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        view.addSubview(logOutButton)
        createConstraints(item: logOutButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 20)
    }
    
    private func configureLabels()
    {
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 20)
        userNameLabel.textColor = .red
        view.addSubview(userNameLabel)
        createConstraints(item: userNameLabel, distFromLeft: 0, distFromTop: Double(view.bounds.height)/10)
        userNameLabel.font = UIFont(name: "markerfelt-wide", size: 20)
        guard let currentUserUserName = InteractiveMapViewController.currentUser?.userName else {
            userNameLabel.text = "User not found"
            return
            
        }
        userNameLabel.text = "Username: \(currentUserUserName)"
        
        
    }
    @objc func logOutPressed(sender: UIButton)
    {
        UserDefaults.standard.removeObject(forKey: "userUsername")
        UserDefaults.standard.removeObject(forKey: "userPassword")
        UserDefaults.standard.removeObject(forKey: "userId")
        InteractiveMapViewController.currentUser = nil
        InteractiveMapViewController.destination = nil
        InteractiveMapViewController.routeInProgress = false
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
extension UserSettingsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userSettingsCell", for: indexPath) as! UserSettingsTableViewCell
        cell.layer.cornerRadius = 15
        cell.backgroundColor = .black
        cell.backView.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: cell.bounds.height)
        cell.setting = options[indexPath.row]
        cell.configure()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserSettingsTableViewCell
        print("test")
        self.tabBarController?.present(cell.setting!.viewController, animated: true)
    }
}
