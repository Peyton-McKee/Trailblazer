//
//  MapSelectorCollectionViewDelegate.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/13/23.
//

import Foundation
import UIKit

extension MapSelectorView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.maps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mapSelectorTableViewCell") as! MapSelectorTableViewCell
        cell.layer.cornerRadius = 8
        cell.backgroundColor = .init(hex: "#9d9d9daa")
        cell.mountainTitle.text = self.maps[indexPath.row].name
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.vc?.switchRootViewController(id: self.maps[indexPath.row].id!)
    }
    
}
