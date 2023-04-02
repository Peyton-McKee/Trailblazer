//
//  SignInViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/25/22.
//

import Foundation
import UIKit

class SignInViewController: UIViewController
{
    lazy var signInView : SignInView = {
        let signInView = SignInView(vc: self)
        return signInView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.signInView)
    }
    
    deinit {
        print("Sign in view controller deinitialized")
    }
    
    @objc func signInButtonPressed(sender: UIButton)
    {
        guard let usernameText = (sender.userActivity?.userInfo?["username"] as? String), let passwordText = (sender.userActivity?.userInfo?["password"] as? String) else {
            self.signInView.displayEmptyUsernameOrPasswordError()
            return
        }
        guard !(usernameText.isEmpty || passwordText.isEmpty) else {
            self.signInView.displayEmptyUsernameOrPasswordError()
            return
        }
        APIHandler.shared.loginHandler(username: usernameText, password: passwordText, completion: {
            result in
            do {
                let user = try result.get()
                DispatchQueue.main.async{
                    InteractiveMapViewController.currentUser = user
                    self.navigationController?.show(MapSelectorViewController(), sender: self)
                    UserDefaults.standard.set("\(user.username)", forKey: "userUsername")
                    UserDefaults.standard.set(user.alertSettings, forKey: "alertSettings")
                    UserDefaults.standard.set("\(user.routingPreference)", forKey: "routingPreference")
                    UserDefaults.standard.set("\(user.id!)", forKey: "userId")
                }
            } catch {
                DispatchQueue.main.async{
                    self.signInView.displayIncorrectUsernameOrPasswordError()
                }
            }
        })
    }
    
    @objc func signUpButtonPressed(sender: UIButton)
    {
        self.navigationController?.show(SignUpViewController(), sender: self)
    }
}
