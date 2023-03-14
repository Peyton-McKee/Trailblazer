//
//  AlertPreferencesView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/14/23.
//

import Foundation
import UIKit

final class AlertPreferencesView: UIView {
    lazy var VStack : UIStackView =
    {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        [self.alertPreferencesLabel, self.mogulToggleOptionView, self.icyToggleOptionView, self.crowdedToggleOptionView, self.thinCoverToggleOptionView, self.longLiftLineToggleOptionView, self.snowmakingToggleOptionView].forEach({
            stack.addArrangedSubview($0)
        })
        return stack
    }()

    let alertPreferencesLabel : UILabel = {
        var label = UILabel()
        label.text = "My Alert Preferences"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var mogulToggleOptionView = ToggleOptionView(type: .moguls, vc: self.vc)

    lazy var icyToggleOptionView = ToggleOptionView(type: .ice, vc: self.vc)

    lazy var crowdedToggleOptionView = ToggleOptionView(type: .crowded, vc: self.vc)

    lazy var thinCoverToggleOptionView = ToggleOptionView(type: .thinCover, vc: self.vc)

    lazy var longLiftLineToggleOptionView = ToggleOptionView(type: .longLiftLine, vc: self.vc)

    lazy var snowmakingToggleOptionView = ToggleOptionView(type: .snowmaking, vc: self.vc)

    weak var vc: AlertPreferencesViewController?

    init(vc: AlertPreferencesViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        
        self.addSubview(self.VStack)
        self.backgroundColor = UIColor(hex: "#101010ff")

        NSLayoutConstraint.activate([
            self.alertPreferencesLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height/10),
            self.VStack.topAnchor.constraint(equalTo: alertPreferencesLabel.topAnchor),
            self.VStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.VStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.VStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
