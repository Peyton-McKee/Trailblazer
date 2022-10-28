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
    var label = UILabel()
    var myImageView = UIImageView()
    
    var backView = UIView()
    
    var setting : Setting?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
    }
    func configure()
    {
        guard let setting = self.setting else {return}
        self.label.frame = CGRect(x: 30, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.label.text = setting.name
        self.label.textColor = setting.textColor
        self.label.font = UIFont(name: "markerfelt-wide", size: 15)
        self.myImageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        self.myImageView.image = setting.image
        backView.addSubview(myImageView)
        backView.addSubview(label)
    }
}
