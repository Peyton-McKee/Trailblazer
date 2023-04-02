//
//  ToggleOptionView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/14/23.
//

import Foundation
import UIKit

final class ToggleOptionView: UIView {
    lazy var HStack : UIStackView  = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.layer.cornerRadius = 8
        stack.layer.shadowRadius = 8
        stack.layer.shadowOpacity = 0.5
        stack.layer.shadowOffset = .zero
        stack.layer.shadowColor = UIColor(hex: "#00000000")?.cgColor
        [self.alertSwitch, self.alertLabel].forEach{
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    
    let alertLabel : UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var alertSwitch : UISwitch = {
        var mySwitch = UISwitch()
        mySwitch.addTarget(self.vc, action: #selector(self.vc?.toggleSwitch), for: .touchUpInside)
        let activity = NSUserActivity(activityType: "toggleAlert")
        activity.userInfo = ["type": self.type.rawValue]
        mySwitch.userActivity = activity
        return mySwitch
    }()
    
    weak var vc : AlertPreferencesViewController?
    
    let type: TrailReportType
    
    init(type: TrailReportType, vc: AlertPreferencesViewController?) {
        self.type = type
        self.vc = vc
        super.init(frame: .zero)
        self.addSubview(self.HStack)
        
        
        if UserDefaults.standard.array(forKey: "alertSettings")!.contains(where: { $0 as! String == type.rawValue})
        {
            self.alertSwitch.isOn = true
        }
        
        self.alertLabel.text = "Receive Alerts For Areas of \(type.rawValue)"
        
        NSLayoutConstraint.activate([
            self.HStack.topAnchor.constraint(equalTo: self.topAnchor),
            self.HStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.HStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.HStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
