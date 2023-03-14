//
//  UserSettingsView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/13/23.
//

import Foundation
import UIKit

final class UserSettingsView: UIView {
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 20)
        label.textColor = .red
        label.font = UIFont(name: "markerfelt-wide", size: 20)
        label.text = "Hello \(InteractiveMapViewController.currentUser.username)!"
        return label
    }()

    let options: [Setting] = [Setting(name: "Trail Reports Made", image: UIImage(systemName: "snowflake")!, textColor: .green, viewController: UserTrailReportsViewController()),  Setting(name: "Alert Preferences", image: UIImage(systemName: "bell.badge")!, textColor: .blue, viewController: AlertPreferencesViewController()), Setting(name: "Preferred Routing", image: UIImage(systemName: "location.circle.fill")!, textColor: .blue, viewController: RoutingPreferencesViewController()), Setting(name: "More Settings", image: UIImage(systemName: "circle")!, textColor: .red, viewController: MoreSettingViewController())]
    
    lazy var backgroundImageView : UIImageView = {
        let backgroundImageView = UIImageView(frame: self.frame)
        backgroundImageView.image = UIImage(named: "SRMoon.png")!
        return backgroundImageView
    }()
    
    lazy var dimmedBackground : UIView = {
        let dimmedBackground = UIView(frame: self.backgroundImageView.frame)
        dimmedBackground.backgroundColor = UIColor(hex: "#000000A0")
        return dimmedBackground
    }()
    
    lazy var settingsTableView : UITableView  = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 15
        tableView.backgroundColor = UIColor(hex: "#00000000")
        tableView.register(UserSettingsTableViewCell.self, forCellReuseIdentifier: "userSettingsCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var VStack : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        [usernameLabel.self, settingsTableView.self].forEach({ stackView.addArrangedSubview($0)})
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    weak var vc: UserSettingsViewController?

    init(vc: UserSettingsViewController){
        self.vc = vc
        super.init(frame: vc.view.frame)
        self.addSubview(self.backgroundImageView)
        self.backgroundImageView.addSubview(self.dimmedBackground)
        self.addSubview(self.VStack)
        
        NSLayoutConstraint.activate([self.usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height/10), VStack.topAnchor.constraint(equalTo: usernameLabel.topAnchor), VStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16), VStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16), VStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


