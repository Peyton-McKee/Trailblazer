//
//  LoadingView.swift
//  SundayRiver
//
//  Created by Peyton McKee on 12/9/22.
//

import Foundation
import UIKit

class LoadingView: UIView {
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
    var calculatingRouteLabel : UILabel = {
        var label = UILabel()
        label.text = "Calculating Route"
        label.textColor = .white
        label.font = UIFont(name: "markerfelt-wide", size: 30)
        return label
    }()
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: "#232323a2")
        self.addSubview(loadingHStack)
        NSLayoutConstraint.activate([loadingHStack.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height/2), loadingHStack.leadingAnchor.constraint(equalTo: self.leadingAnchor), loadingHStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        print(self.frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
