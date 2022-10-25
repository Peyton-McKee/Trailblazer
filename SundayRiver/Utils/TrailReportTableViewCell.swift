//
//  TrailReportTableViewCell.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/25/22.
//

import Foundation
import UIKit

class TrailReportTableViewCell : UITableViewCell
{
    var trailReportTypeLabel = UILabel()
    
    var backView = UIView()
    
    var cellTrailReport: TrailReport?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure()
    {
        backView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        addSubview(backView)
        backView.layer.cornerRadius = 15
        backView.backgroundColor = .darkGray
        backView.addSubview(trailReportTypeLabel)
        trailReportTypeLabel.text = cellTrailReport?.type
        trailReportTypeLabel.textColor = .white
        trailReportTypeLabel.frame = CGRect(x: backView.frame.minX, y: backView.frame.minY, width: backView.bounds.width, height: backView.bounds.height)
    }
}
