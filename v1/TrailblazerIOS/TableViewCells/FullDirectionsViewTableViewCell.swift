//
//  FullDirectionsViewTableViewCell.swift
//  Trailblazer
//
//  Created by Peyton McKee on 4/20/23.
//

import Foundation
import UIKit

final class FullDirectionsViewTableViewCell: UITableViewCell {
    lazy var view : DirectionsView = DirectionsView()

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(_ view: DirectionsView) {
        self.view = view
        self.addSubview(view)
        NSLayoutConstraint.activate([self.view.leadingAnchor.constraint(equalTo: self.leadingAnchor), self.view.trailingAnchor.constraint(equalTo: self.trailingAnchor), self.view.topAnchor.constraint(equalTo: self.topAnchor), self.view.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
}
