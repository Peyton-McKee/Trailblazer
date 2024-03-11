//
//  FullDirectionsView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 4/20/23.
//

import Foundation
import UIKit

final class FullDirectionView: UIView {
    var directions: [DirectionsView] = []
    
    lazy var directionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FullDirectionsViewTableViewCell.self, forCellReuseIdentifier: "FullDirectionsViewTableViewCell")
        return tableView
    }()
    
    lazy var VStack : UIStackView = {
        let stackView = UIStackView(frame: self.frame)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.backgroundColor = .black
        [directionsTableView.self, closeButton.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.setTitle("CLOSE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.VStack)
        NSLayoutConstraint.activate([self.directionsTableView.leadingAnchor.constraint(equalTo: self.VStack.leadingAnchor), self.directionsTableView.trailingAnchor.constraint(equalTo: self.VStack.trailingAnchor), self.directionsTableView.topAnchor.constraint(equalTo: self.VStack.topAnchor), self.directionsTableView.bottomAnchor.constraint(equalTo: self.closeButton.topAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDirections(directions: [DirectionsView]) {
        self.directions = directions
        self.directionsTableView.reloadData()
        self.directionsTableView.frame = CGRect(x: 0, y: 0, width: self.VStack.frame.width, height: self.VStack.frame.height - self.closeButton.frame.height)
    }
    
}

extension FullDirectionView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.directions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FullDirectionsViewTableViewCell", for: indexPath) as! FullDirectionsViewTableViewCell
        cell.updateView(directions[indexPath.row])
        return cell
    }
    
    
    
}
