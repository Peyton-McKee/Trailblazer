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
    lazy var HStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        [self.trailReportTypeLabel, self.trailReportTrailMadeOnLabel, self.trailReportDateLabel].forEach({
            stackView.addArrangedSubview($0)
        })
        return stackView
    }()
    
    var trailReportTypeLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hex: "#de82f2ff")
        label.font = .Theme.markerFelt
        return label
    }()
    
    var trailReportDateLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hex: "#de82f2ff")
        label.font = .Theme.markerFelt
        return label
    }()
    
    var trailReportTrailMadeOnLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor(hex: "#de82f2ff")
        label.font = .Theme.markerFelt
        return label
    }()
    
    var backView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.backgroundColor = CGColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        return view
    }()
    
    var cellTrailReport: TrailReport?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    func configure()
    {
        addSubview(backView)
        backView.addSubview(HStack)
        trailReportDateLabel.text = "\(cellTrailReport!.dateMade.prefix(upTo: String.Index.init(utf16Offset: 10, in: cellTrailReport!.dateMade)))"
        trailReportTypeLabel.text = "\(cellTrailReport!.type)"
        trailReportTrailMadeOnLabel.text = "\(cellTrailReport!.trailMadeOn)"
        
        HStack.frame = CGRect(x: backView.bounds.minX + 10, y: backView.frame.minY, width: backView.bounds.width - 10, height: backView.bounds.height)
        
    }
}
