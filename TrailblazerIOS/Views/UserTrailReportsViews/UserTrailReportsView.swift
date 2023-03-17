//
//  UserTrailReportsView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/14/23.
//

import Foundation
import UIKit

final class UserTrailReportsView : UIView {
    var trailReports : [TrailReport] = []
    
    lazy var trailReportsTableView : UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 15
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TrailReportTableViewCell.self, forCellReuseIdentifier: "trailReportTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(hex: "#00000000")
        return tableView
    }()
    
    let myTrailReportLabel : UILabel = {
        let label = UILabel()
        label.text = "My Trail Reports"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .Theme.markerFelt
        return label
    }()
    
    lazy var VStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        [myTrailReportLabel.self, trailReportsTableView.self].forEach{ stack.addArrangedSubview($0) }
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 0.6, green: 0, blue: 0, alpha: 0.9)
        self.addSubview(self.VStack)
        NSLayoutConstraint.activate([self.myTrailReportLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height/10), self.trailReportsTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor), self.VStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     self.VStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     self.VStack.topAnchor.constraint(equalTo: self.myTrailReportLabel.topAnchor),
                                     self.VStack.bottomAnchor.constraint(equalTo: self.trailReportsTableView.bottomAnchor),
                                     self.trailReportsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                                     self.trailReportsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayTrailReports(trailReports: [TrailReport]) {
        self.trailReports = trailReports
        self.trailReportsTableView.reloadData()
    }
}
