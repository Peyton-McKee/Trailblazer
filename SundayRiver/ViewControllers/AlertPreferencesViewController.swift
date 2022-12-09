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
        [self.alertPreferencesLabel, self.mogulHStack, self.icyHStack, self.crowdedHStack, self.thinCoverHStack].forEach({
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
            alertPreferencesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            VStack.topAnchor.constraint(equalTo: alertPreferencesLabel.topAnchor),
            VStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            VStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
    }
    @objc func toggleSwitch(sender: UISwitch)
    {
        if sender.isOn
        {
            switch sender{
            case mogulAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.moguls.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.moguls.rawValue}){
                    InteractiveMapViewController.notiAnnotation = trailReport
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil)
                    
                }
            case icyAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.ice.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.ice.rawValue}){
                    InteractiveMapViewController.notiAnnotation = trailReport
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil)
                    
                }
            case crowdedAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.crowded.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.crowded.rawValue}){
                    InteractiveMapViewController.notiAnnotation = trailReport
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil)
                    
                }
            case thinCoverAlertSwitch:
                InteractiveMapViewController.currentUser.alertSettings.append(TrailReportType.thinCover.rawValue)
                for trailReport in InteractiveMapViewController.trailReports.filter({$0.type == TrailReportType.thinCover.rawValue}){
                    InteractiveMapViewController.notiAnnotation = trailReport
                    NotificationCenter.default.post(name: Notification.Name("createNotification"), object: nil)
                    
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

            default:
                break
            }
        }
        
        UserDefaults.standard.set(InteractiveMapViewController.currentUser.alertSettings, forKey: "alertSettings")
        updateUser(InteractiveMapViewController.currentUser)
    }
}
