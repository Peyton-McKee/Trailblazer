//
//  MapSelectorView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/13/23.
//

import Foundation
import UIKit

final class MapSelectorView : UIView {
    var maps: [MapPreview] = []
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: self.frame.minX + 16, y: self.frame.minY + 16, width: self.frame.width - 32, height: self.frame.height - 16))
        tableView.register(MapSelectorTableViewCell.self, forCellReuseIdentifier: "mapSelectorTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    weak var vc: MapSelectorViewController?
    
    init(vc: MapSelectorViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        self.addSubview(self.tableView)
        self.tableView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayOptions(maps: [MapPreview]) {
        self.maps = maps
        self.tableView.reloadData()
    }
}
