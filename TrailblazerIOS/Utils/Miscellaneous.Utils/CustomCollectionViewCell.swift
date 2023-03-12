//
//  CollectionViewCell.swift
//  Trailblazer
//
//  Created by Peyton McKee on 1/29/23.
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        label.frame = CGRect(x: 20, y: 20, width: 100, height: 20)
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
