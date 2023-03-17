//
//  RetrievingMapLoadingView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 1/27/23.
//

import Foundation
import UIKit

class RetrievingMapLoadingView: UIView {
    lazy var loadingHStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        [calculatingRouteLabel.self, activityIndicator.self].forEach{ stackView.addArrangedSubview($0)}
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    var activityIndicator: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.style = .large
        indicator.color = .white

        return indicator
    }()
    var backgroundImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "SRMoon.png")
        return imageView
    }()
    var calculatingRouteLabel : UILabel = {
        var label = UILabel()
        label.text = "Retrieving Map Data"
        label.textColor = .white
        label.font = .Theme.markerFelt
        return label
    }()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#232323a2")
        self.backgroundImageView.frame = frame
        self.addSubview(backgroundImageView)
        self.addSubview(loadingHStack)
        NSLayoutConstraint.activate([loadingHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height/2), loadingHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor), loadingHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
