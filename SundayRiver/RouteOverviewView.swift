//
//  RouteOverviewView.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/13/22.
//

import Foundation
import UIKit


class RouteOverviewView : UIView {
    var tripLbl = UILabel()
    var directionsTextView = UITextView()
    var letsGoButton = UIButton()
    var trailReportTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureItems()
    {
        self.tripLbl.translatesAutoresizingMaskIntoConstraints = false
        self.tripLbl.textAlignment = .center
        self.tripLbl.layer.cornerRadius = 10
        
        self.directionsTextView.translatesAutoresizingMaskIntoConstraints = false
        self.directionsTextView.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 15)
        self.directionsTextView.isEditable = false
        
        self.trailReportTextView.translatesAutoresizingMaskIntoConstraints = false
        self.trailReportTextView.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 10)
        self.trailReportTextView.isEditable = false
        
        self.letsGoButton.translatesAutoresizingMaskIntoConstraints = false
        self.letsGoButton.backgroundColor = .blue
        self.letsGoButton.setTitle("Let's Go!", for: .normal)
        self.letsGoButton.layer.cornerRadius = 15
        
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 15
        
        self.addSubview(tripLbl)
        self.addSubview(directionsTextView)
        self.addSubview(letsGoButton)
        self.addSubview(trailReportTextView)
        NSLayoutConstraint.activate([
            tripLbl.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 0),
            tripLbl.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: 0),
            tripLbl.heightAnchor.constraint(equalToConstant: 40),
            tripLbl.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 0),
            directionsTextView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 0),
            directionsTextView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: 0),
            directionsTextView.heightAnchor.constraint(equalToConstant: 50),
            directionsTextView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 40),
            trailReportTextView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 0),
            trailReportTextView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: 0),
            trailReportTextView.heightAnchor.constraint(equalToConstant: 30),
            trailReportTextView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 90),
            letsGoButton.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 0),
            letsGoButton.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: 0),
            letsGoButton.heightAnchor.constraint(equalToConstant: 40),
            letsGoButton.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 140)])
    }
}
