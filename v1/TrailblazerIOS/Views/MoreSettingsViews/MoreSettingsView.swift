//
//  MoreSettingsView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/14/23.
//

import Foundation
import UIKit

final class MoreSettingsView: UIView {
    lazy var logOutButton : UIButton = {
        var button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = .Theme.markerFelt
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .Theme.intermediateColor
        button.addTarget(self.vc, action: #selector(self.vc?.logOutPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let moreSettingsLabel : UILabel = {
        var label = UILabel()
        label.text = "More Settings"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pageVStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        [moreSettingsLabel.self, formVStack.self, logOutButton.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    lazy var formVStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.layer.shadowRadius = 8
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowOpacity = 0.5
        stackView.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        stackView.layer.backgroundColor = UIColor.white.cgColor
        stackView.layer.borderColor = UIColor.darkGray.cgColor
        stackView.layer.borderWidth = 1
        [titleLabel.self, entryHStack.self, submitButton.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    let titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Upload or edit a map"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.backgroundColor = UIColor.gray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    lazy var entryHStack : UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [selectAFileButton.self, linkTextField.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    lazy var selectAFileButton: UIButton = {
        var button = UIButton()
        button.setTitle("Choose File", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self.vc, action: #selector(self.vc?.selectFiles), for: .touchUpInside)
        return button
    }()
    
    lazy var linkTextField: UITextField = {
        var textField = UITextField()
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "Enter link for mountain report..."
        textField.delegate = self
        return textField
    }()
    
    lazy var submitButton: UIButton = {
        var button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .Theme.easyColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self.vc, action: #selector(self.vc?.submitFiles), for: .touchUpInside)
        let activity = NSUserActivity(activityType: "makeMapFile")
        activity.userInfo = ["link": ""]
        button.userActivity = activity
        return button
    }()
    
    weak var vc: MoreSettingViewController?
    
    init(vc: MoreSettingViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        
        self.addSubview(self.pageVStack)
        
        NSLayoutConstraint.activate([
            self.moreSettingsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height * (3/20)),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 40),
            self.pageVStack.topAnchor.constraint(equalTo: self.moreSettingsLabel.topAnchor),
            self.pageVStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.pageVStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
