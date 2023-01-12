//
//  UserSettingsViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/10/22.
//

import Foundation
import UIKit

class UserSettingsViewController : UIViewController {
    
    var userNameLabel : UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 20)
        label.textColor = .red
        label.font = UIFont(name: "markerfelt-wide", size: 20)
        return label
    }()
    let options: [Setting] = [Setting(name: "Trail Reports Made", image: UIImage(systemName: "snowflake")!, textColor: .green, viewController: UserTrailReportsViewController()),  Setting(name: "Alert Preferences", image: UIImage(systemName: "bell.badge")!, textColor: .blue, viewController: AlertPreferencesViewController()), Setting(name: "Preferred Routing", image: UIImage(systemName: "location.circle.fill")!, textColor: .blue, viewController: RoutingPreferencesViewController()), Setting(name: "More Settings", image: UIImage(systemName: "circle")!, textColor: .red, viewController: MoreSettingViewController())]
    
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
        [userNameLabel.self, settingsTableView.self].forEach({ stackView.addArrangedSubview($0)})
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
        NSLayoutConstraint.activate([userNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/10), VStack.topAnchor.constraint(equalTo: userNameLabel.topAnchor), VStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), VStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16), VStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameLabel.text = "Hello \(InteractiveMapViewController.currentUser.username)!"
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
        
        self.navigationController?.show(cell.setting!.viewController, sender: self)
    }
}
