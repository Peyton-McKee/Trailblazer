//
//  UserSettingsViewTableViewDelegate.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/13/23.
//

import Foundation
import UIKit

extension UserSettingsView: UITableViewDelegate, UITableViewDataSource
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
        self.vc?.cellSelected(cell: cell)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
