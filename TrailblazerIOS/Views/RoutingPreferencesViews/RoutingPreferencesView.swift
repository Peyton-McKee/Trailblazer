//
//  RoutingPreferencesView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/14/23.
//

import Foundation
import UIKit

final class RoutingPreferencesView: UIView {
    lazy var VStack : UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [self.titleLabel, self.HStack].forEach{ stackView.addArrangedSubview($0)}
        return stackView
    }()
    
    let titleLabel : UILabel = {
        var label = UILabel()
        label.text = "Routing Settings"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var HStack : UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.layer.cornerRadius = 15
        [self.routingLabel, self.routingPickerView].forEach{ stackView.addArrangedSubview($0)}
        stackView.layer.shadowRadius = 10
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowOpacity = 0.5
        stackView.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        return stackView
    }()
    
    lazy var routingPickerView : UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        switch UserDefaults.standard.string(forKey: "routingPreference"){
        case RoutingType.easiest.rawValue:
            pickerView.selectRow(0, inComponent: 0, animated: false)
        case RoutingType.quickest.rawValue:
            pickerView.selectRow(1, inComponent: 0, animated: false)
        case RoutingType.leastDistance.rawValue:
            pickerView.selectRow(2, inComponent: 0, animated: false)
        default:
            break
        }
        return pickerView
    }()
    
    var routingLabel : UILabel = {
        var label = UILabel()
        label.text = "Select Your Preferred Routing Type:"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var options : [RoutingType] = [.easiest, .quickest, .leastDistance]
    
    weak var vc: RoutingPreferencesViewController?
    
    init(vc: RoutingPreferencesViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        
        self.backgroundColor = UIColor(hex: "#101010ff")
        self.addSubview(self.VStack)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.bounds.height * (3/20)),
            self.VStack.topAnchor.constraint(equalTo: self.titleLabel.topAnchor),
            self.VStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.VStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
