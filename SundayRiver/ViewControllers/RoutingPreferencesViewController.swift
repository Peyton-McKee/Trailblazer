//
//  RoutingPreferencesViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 12/3/22.
//

import Foundation
import UIKit

class RoutingPreferencesViewController: UIViewController {
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
    var titleLabel : UILabel = {
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
        stackView.backgroundColor = UIColor(hex: "#ae82f2a7")
        [self.routingLabel, self.routingPickerView].forEach{ stackView.addArrangedSubview($0)}
        return stackView
    }()
    lazy var routingPickerView : UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    private func configureView()
    {
        view.backgroundColor = UIColor(hex: "#101010ff")
        view.addSubview(VStack)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            VStack.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            VStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            VStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)])
    }
}

extension RoutingPreferencesViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].rawValue
    }
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        return NSAttributedString(string: options[row].rawValue, attributes: [NSAttributedString.Key.foregroundColor: UIColor.yellow])
//    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        InteractiveMapViewController.currentUser?.routingPreference = options[row].rawValue
    }
}
