//
//  UserSettingsTableViewCell.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/25/22.
//

import Foundation
import UIKit

class UserSettingsTableViewCell : UITableViewCell
{
    lazy var label : UILabel = {
        var label = UILabel()
        label.font = .Theme.markerFelt
        guard let setting = self.setting else {return label}
        label.text = setting.name
        label.textColor = setting.textColor
        return label
    }()

    lazy var myImageView : UIImageView  = {
        var imageView = UIImageView()
        imageView.tintColor = .systemBlue
        guard let setting = self.setting else {return imageView}
        imageView.image = setting.image
        return imageView
    }()
    
    lazy var HStack : UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 10
        [myImageView.self, label.self].forEach{ stackView.addArrangedSubview($0)}
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var setting : Setting?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure()
    {
        self.addSubview(self.HStack)
        NSLayoutConstraint.activate([self.HStack.leadingAnchor.constraint(equalTo: self.leadingAnchor), self.HStack.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height/2 - 7.5)])
    }
}
