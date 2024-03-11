//
//  CollectionViewCell.swift
//  Trailblazer
//
//  Created by Peyton McKee on 1/29/23.
//

import Foundation
import UIKit

class MapSelectorTableViewCell: UITableViewCell {
    
    let mountainTitle : UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    let numTrailsLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    
    lazy var HStack : UIStackView = {
        let stack = UIStackView(frame: self.frame)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        [mountainTitle.self, numTrailsLabel.self].forEach({stack.addArrangedSubview($0)})
        return stack
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.addSubview(self.HStack)
    }
}
