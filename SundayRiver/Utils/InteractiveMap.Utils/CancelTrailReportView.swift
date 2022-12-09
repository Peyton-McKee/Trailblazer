//
//  CancelTrailReportView.swift
//  SundayRiver
//
//  Created by Peyton McKee on 11/5/22.
//

import Foundation
import UIKit

final class CancelTrailReportView: UIView{
    
    var backgroundView = UIView()
    var notThereUIButton = UIButton()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configure()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 15
        
        notThereUIButton.translatesAutoresizingMaskIntoConstraints = false
        notThereUIButton.setTitle("No longer There?", for: .normal)
        notThereUIButton.titleLabel!.font = UIFont(name: "markerfelt.wide", size: 20)
        backgroundView.backgroundColor = UIColor(hex: "#E6B400D0")
        
        self.addSubview(backgroundView)
        backgroundView.addSubview(notThereUIButton)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            notThereUIButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            notThereUIButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            notThereUIButton.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            notThereUIButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)])
    }
}
