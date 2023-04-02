//
//  UserSettingsViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/10/22.
//

import Foundation
import UIKit

class UserSettingsViewController : UIViewController {
    lazy var userSettingsView = UserSettingsView(vc: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.view.addSubview(userSettingsView)
    }
    
    func cellSelected(cell: UserSettingsTableViewCell) {
        self.navigationController?.show(cell.setting!.viewController, sender: self)
    }
}
