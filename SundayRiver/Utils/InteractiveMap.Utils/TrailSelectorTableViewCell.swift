//
//  CustomCell.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/28/22.
//

import Foundation
import UIKit

class TrailSelectorTableViewCell : UITableViewCell
{
    lazy var label: UILabel = {
       let lbl = UILabel(frame: CGRect(x: 10, y: 10, width: self.frame.width - 80, height: 30))
        return lbl
    }()
    
    lazy var backView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        return view
    }()
    
    var cellTrail : Trail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(backView)
        backView.addSubview(label)
        // Configure the view for the selected state
    }
}
