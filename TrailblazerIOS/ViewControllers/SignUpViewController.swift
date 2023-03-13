//
//  SignUpViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/4/22.
//

import Foundation
import UIKit

class SignUpViewController : UIViewController {
    
    lazy var signUpView : SignUpView = {
       let signUpView = SignUpView(vc: self)
        
        return signUpView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(self.signUpView)
    }
    
    
    @objc func signUpButtonPressed(sender: UIButton)
    {
        guard let usernameText = sender.userActivity?.userInfo?["username"] as? String, let passwordText = sender.userActivity?.userInfo?["password"] as? String, let confirmPasswordText = sender.userActivity?.userInfo?["confirmPassword"] as? String else {
            self.signUpView.displayEmptyUsernameOrPasswordError()
            return
        }
        guard passwordText == confirmPasswordText else
        {
            self.signUpView.displayNonMatchingPasswordsError()
            return //display text saying passwords do not match
        }
        guard !(passwordText.isEmpty && confirmPasswordText.isEmpty && usernameText.isEmpty) else {
            self.signUpView.displayEmptyUsernameOrPasswordError()
            return
        }
        saveUser(User(username: usernameText, password: passwordText, alertSettings: [], routingPreference: RoutingType.easiest.rawValue), completion: {
            value in
            guard let user = try? value.get() else
            {
                DispatchQueue.main.async{
                    self.signUpView.displayUsernameAlreadyTakenError()
                    print("Error: Couldnt save user")
                    return
                }
                return
            }
            DispatchQueue.main.async{
                InteractiveMapViewController.currentUser = user
                self.navigationController?.show(MapSelectorViewController(), sender: self)
                UserDefaults.standard.set("\(user.username)", forKey: "userUsername")
                UserDefaults.standard.set(user.alertSettings, forKey: "alertSettings")
                UserDefaults.standard.set("\(user.routingPreference)", forKey: "routingPreference")
                UserDefaults.standard.set("\(user.id!)", forKey: "userId")
            }
        })
    }
    @objc func signInButtonPressed(sender: UIButton)
    {
        self.navigationController?.show(SignInViewController(), sender: self)
    }
    
}

