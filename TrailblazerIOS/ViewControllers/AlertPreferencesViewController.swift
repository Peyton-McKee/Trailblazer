//
//  AlertPreferencesViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 12/3/22.
//

import Foundation
import UIKit

class AlertPreferencesViewController: UIViewController {
    
    lazy var VStack : UIStackView =
    {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        [self.alertPreferencesLabel, self.mogulHStack, self.icyHStack, self.crowdedHStack, self.thinCoverHStack, self.longLiftLineHStack, self.snowmakingHStack].forEach({
            stack.addArrangedSubview($0)
        })
        return stack
    }()
    var alertPreferencesLabel : UILabel = {
        var label = UILabel()
        label.text = "My Alert Preferences"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var mogulHStack : UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.layer.cornerRadius = 8
        stack.layer.shadowRadius = 8
        stack.layer.shadowOffset = .zero
        stack.layer.shadowOpacity = 0.5
        stack.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        stack.layer.backgroundColor = UIColor(hex: "#ae82f2a7")?.cgColor
        [self.mogulAlertSwitch, self.mogulAlertLabel].forEach{
            stack.addArrangedSubview($0)
        }
        return stack
    }()
    var mogulAlertLabel : UILabel = {
        var label = UILabel()
        label.text = "Receive Alerts For Moguls?"
        label.textColor = .white
        return label
    }()
    lazy var mogulAlertSwitch : UISwitch = {
        var mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        if UserDefaults.standard.array(forKey: "alertSettings")!.contains(where: { $0 as! String == TrailReportType.moguls.rawValue})
        {
            mySwitch.isOn = true
        }
        return mySwitch
    }()
    lazy var icyHStack : UIStackView  = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.layer.cornerRadius = 8
        stack.layer.backgroundColor = UIColor(hex: "#ae82f2a7")?.cgColor
        [self.icyAlertSwitch, self.icyAlertLabel].forEach{
            stack.addArrangedSubview($0)
        }
        stack.layer.shadowRadius = 8
        stack.layer.shadowOffset = .zero
        stack.layer.shadowOpacity = 0.5
        stack.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        return stack
    }()
    var icyAlertLabel : UILabel = {
        var label = UILabel()
        label.text = "Receive Alerts For Ice?"
        label.textColor = .white
        return label
    }()
    lazy var icyAlertSwitch : UISwitch = {
        var mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        if UserDefaults.standard.array(forKey: "alertSettings")!.contains(where: { $0 as! String == TrailReportType.ice.rawValue})
        {
            mySwitch.isOn = true
        }
        return mySwitch
    }()
    lazy var crowdedHStack : UIStackView  = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.layer.cornerRadius = 8
        stack.layer.backgroundColor = UIColor(hex: "#ae82f2a7")?.cgColor
        [self.crowdedAlertSwitch, self.crowdedAlertLabel].forEach{
            stack.addArrangedSubview($0)
        }
        stack.layer.shadowRadius = 8
        stack.layer.shadowOffset = .zero
        stack.layer.shadowOpacity = 0.5
        stack.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        return stack
    }()
    var crowdedAlertLabel : UILabel = {
        var label = UILabel()
        label.text =  "Receive Alerts For Crowded Locations?"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    lazy var crowdedAlertSwitch : UISwitch = {
        var mySwitch = UISwitch()
        if UserDefaults.standard.array(forKey: "alertSettings")!.contains(where: { $0 as! String == TrailReportType.crowded.rawValue})
        {
            mySwitch.isOn = true
        }
        mySwitch.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        return mySwitch
    }()
    lazy var thinCoverHStack : UIStackView  = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.layer.cornerRadius = 8
        stack.layer.backgroundColor = UIColor(hex: "#ae82f2a7")?.cgColor
        [self.thinCoverAlertSwitch, self.thinCoverAlertLabel].forEach{
            stack.addArrangedSubview($0)
        }
        stack.layer.shadowRadius = 8
        stack.layer.shadowOffset = .zero
        stack.layer.shadowOpacity = 0.5
        stack.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        return stack
    }()
    var thinCoverAlertLabel : UILabel = {
        var label = UILabel()
        label.text =  "Receive Alerts For Areas of Thin Cover?"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    lazy var thinCoverAlertSwitch : UISwitch = {
        var mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        if UserDefaults.standard.array(forKey: "alertSettings")!.contains(where: { $0 as! String == TrailReportType.thinCover.rawValue})
        {
            mySwitch.isOn = true
        }
        return mySwitch
    }()
    lazy var longLiftLineHStack : UIStackView  = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.layer.cornerRadius = 8
        stack.layer.backgroundColor = UIColor(hex: "#ae82f2a7")?.cgColor
        [self.longLiftLineAlertSwitch, self.longLiftLineAlertLabel].forEach{
            stack.addArrangedSubview($0)
        }
        stack.layer.shadowRadius = 8
        stack.layer.shadowOffset = .zero
        stack.layer.shadowOpacity = 0.5
        stack.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        return stack
    }()
    var longLiftLineAlertLabel : UILabel = {
        var label = UILabel()
        label.text =  "Receive Alerts For Long Lift Lines"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    lazy var longLiftLineAlertSwitch : UISwitch = {
        var mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        if UserDefaults.standard.array(forKey: "alertSettings")!.contains(where: { $0 as! String == TrailReportType.longLiftLine.rawValue})
        {
            mySwitch.isOn = true
        }
        return mySwitch
    }()
    lazy var snowmakingHStack : UIStackView  = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        stack.layer.cornerRadius = 8
        stack.layer.backgroundColor = UIColor(hex: "#ae82f2a7")?.cgColor
        [self.snowmakingAlertSwitch, self.snowmakingAlertLabel].forEach{
            stack.addArrangedSubview($0)
        }
        stack.layer.shadowRadius = 8
        stack.layer.shadowOffset = .zero
        stack.layer.shadowOpacity = 0.5
        stack.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        return stack
    }()
    var snowmakingAlertLabel : UILabel = {
        var label = UILabel()
        label.text =  "Receive Alerts For Snowmaking"
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    lazy var snowmakingAlertSwitch : UISwitch = {
        var mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
        if UserDefaults.standard.array(forKey: "alertSettings")!.contains(where: { $0 as! String == TrailReportType.snowmaking.rawValue})
        {
            mySwitch.isOn = true
        }
        return mySwitch
    }()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureView()
    }
    private func configureView()
    {
        view.addSubview(VStack)
        view.backgroundColor = UIColor(hex: "#101010ff")
        NSLayoutConstraint.activate([
            alertPreferencesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/10),
            VStack.topAnchor.constraint(equalTo: alertPreferencesLabel.topAnchor),
            VStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            VStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            VStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)])
    }
    @objc func toggleSwitch(sender: UISwitch)
    {
        if sender.isOn
        {
            switch sender{
            case mogulAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.moguls.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.moguls.rawValue}){
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil, userInfo: ["report": trailReport])
                }
            case icyAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.ice.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.ice.rawValue}){
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil, userInfo: ["report": trailReport])
                }
            case crowdedAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.crowded.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.crowded.rawValue}){
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil, userInfo: ["report": trailReport])
                }
            case thinCoverAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.thinCover.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.thinCover.rawValue}){
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil, userInfo: ["report": trailReport])
                }
            case longLiftLineAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.longLiftLine.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.longLiftLine.rawValue})
                {
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil, userInfo: ["report": trailReport])
                }
            case snowmakingAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.snowmaking.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.snowmaking.rawValue})
                {
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil, userInfo: ["report": trailReport])
                }
            default:
                break
            }
        }
        else
        {
            switch sender{
            case mogulAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.removeAll(where: { $0 == TrailReportType.moguls.rawValue})
                LocationManager().unregesterNotification(for: TrailReportType.moguls.rawValue)
            case icyAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.removeAll(where: {$0 == TrailReportType.ice.rawValue})
                LocationManager().unregesterNotification(for: TrailReportType.ice.rawValue)
            case crowdedAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.removeAll(where: {$0 == TrailReportType.crowded.rawValue})
                LocationManager().unregesterNotification(for: TrailReportType.crowded.rawValue)
            case thinCoverAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.removeAll(where: {$0 == TrailReportType.thinCover.rawValue})
                LocationManager().unregesterNotification(for: TrailReportType.thinCover.rawValue)
            case longLiftLineAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.removeAll(where: {$0 == TrailReportType.longLiftLine.rawValue})
                LocationManager().unregesterNotification(for: TrailReportType.longLiftLine.rawValue)
            case longLiftLineAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.removeAll(where: {$0 == TrailReportType.snowmaking.rawValue})
                LocationManager().unregesterNotification(for: TrailReportType.snowmaking.rawValue)
            default:
                break
            }
        }
        UserDefaults.standard.set(InteractiveMapViewController.currentUser.alertSettings, forKey: "alertSettings")
        updateUser(InteractiveMapViewController.currentUser)
    }
}
