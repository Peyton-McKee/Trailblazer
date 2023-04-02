//
//  ViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 3/8/22.
//

import UIKit

class TitleViewController: UIViewController{
    lazy var titleView : TitleView = {
        let titleView = TitleView(vc: self)
        return titleView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.titleView)
    }

    deinit {
        print("Deinitialized title view controller")
    }

    @objc func toInteractiveMap(sender: UIButton!)
    {
        UserDefaults.standard.set("Guest", forKey: "userUsername")
        UserDefaults.standard.set("", forKey: "userPassword")
        UserDefaults.standard.set([], forKey: "alertSettings")
        UserDefaults.standard.set(RoutingType.easiest.rawValue, forKey: "routingPreference")
        self.navigationController?.show(MapSelectorViewController(), sender: self)
        InteractiveMapViewController.currentUser = User(username: "Guest", password: "", alertSettings: [], routingPreference: RoutingType.easiest.rawValue)
    }

    @objc func signInOrSignUp(sender: UIButton!)
    {
        switch sender {
        case self.titleView.signUpButton:
            self.navigationController?.show(SignUpViewController(), sender: self)
        default:
            self.navigationController?.show(SignInViewController(), sender: self)
        }
    }
}

