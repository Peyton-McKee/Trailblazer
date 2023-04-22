//
//  TrailReportTypeTableViewCell.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/13/22.
//

import UIKit

class TrailReportTypeTableViewCell: UITableViewCell {
    
    lazy var backView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        return view
    }()
    
    lazy var settingImage: UIImageView = {
       let imageView = UIImageView(frame: CGRect(x: 15, y: 10, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var lbl: UILabel = {
       let lbl = UILabel(frame: CGRect(x: 60, y: 10, width: self.frame.width - 80, height: 30))
        return lbl
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.addSubview(backView)
        self.backView.addSubview(self.settingImage)
        self.backView.addSubview(self.lbl)
        // Configure the view for the selected state
    }

}
