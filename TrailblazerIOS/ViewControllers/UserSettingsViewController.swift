//
//  UserSettingsViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/10/22.
//

import Foundation
import UIKit

class UserSettingsViewController : UIViewController {
    lazy var logOutButton : UIButton = {
        var button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont(name: "markerfelt-wide", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var userNameLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 20)
        label.textColor = .red
        label.font = UIFont(name: "markerfelt-wide", size: 20)
        label.text = "Username: \(InteractiveMapViewController.currentUser.username)"
        return label
    }()
    let options: [Setting] = [Setting(name: "Trail Reports Made", image: UIImage(systemName: "snowflake")!, textColor: .green, viewController: UserTrailReportsViewController()),  Setting(name: "Alert Preferences", image: UIImage(systemName: "bell.badge")!, textColor: .blue, viewController: AlertPreferencesViewController()), Setting(name: "Preferred Routing", image: UIImage(systemName: "location.circle.fill")!, textColor: .blue, viewController: RoutingPreferencesViewController()), Setting(name: "More Settings", image: UIImage(systemName: "circle")!, textColor: .red, viewController: UserTrailReportsViewController())]
    
    var backgroundImageView = UIImageView()
    
    var dimmedBackground = UIView()
    
    lazy var settingsTableView : UITableView = {
        var tableView = UITableView()
        tableView.layer.cornerRadius = 15
        tableView.backgroundColor = UIColor(hex: "#00000000")
        tableView.register(UserSettingsTableViewCell.self, forCellReuseIdentifier: "userSettingsCell")
        
        return tableView
    }()
    
    
    lazy var VStack : UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        [userNameLabel.self, settingsTableView.self, logOutButton.self].forEach({ stackView.addArrangedSubview($0)})
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        backgroundImageView.image = UIImage(named: "SRMoon.png")!
        backgroundImageView.frame = view.frame
        dimmedBackground.backgroundColor = UIColor(hex: "#000000A0")
        dimmedBackground.frame = backgroundImageView.frame
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(dimmedBackground)
        view.addSubview(VStack)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        NSLayoutConstraint.activate([userNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/10), logOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height/5), VStack.topAnchor.constraint(equalTo: userNameLabel.topAnchor), VStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), VStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), VStack.bottomAnchor.constraint(equalTo: logOutButton.bottomAnchor)])
    }
    
    @objc func logOutPressed(sender: UIButton)
    {
        UserDefaults.standard.removeObject(forKey: "userUsername")
        UserDefaults.standard.removeObject(forKey: "userPassword")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "alertSettings")
        UserDefaults.standard.removeObject(forKey: "routingPreference")
        InteractiveMapViewController.currentUser = User(username: "Guest", password: "", alertSettings: [], routingPreference: "")
        InteractiveMapViewController.destination = nil
        InteractiveMapViewController.routeInProgress = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
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
        cell.setting = options[indexPath.row]
        cell.configure()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserSettingsTableViewCell
        print("test")
        
        self.tabBarController?.present(cell.setting!.viewController, animated: true)
    }
}
