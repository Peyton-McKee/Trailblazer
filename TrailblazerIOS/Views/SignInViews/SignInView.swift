//
//  SignInView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/12/23.
//

import Foundation
import UIKit

final class SignInView: UIView {
    lazy var usernameTextField : UITextField = {
        let usernameTextField = UITextField()
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.placeholder = "Enter Username..."
        usernameTextField.delegate = self
        usernameTextField.backgroundColor = .lightGray
        usernameTextField.autocapitalizationType = .none
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.autocorrectionType = .no
        usernameTextField.tag = 1
        return usernameTextField
    }()
    
    lazy var passwordTextField : UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Enter Password..."
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = .lightGray
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocorrectionType = .no
        passwordTextField.tag = 2
        return passwordTextField
    }()
    
    lazy var signInButton : UIButton = {
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Continue", for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.backgroundColor = .cyan
        signInButton.addTarget(self.vc, action: #selector(self.vc?.signInButtonPressed), for: .touchUpInside)
        let activity = NSUserActivity(activityType: "signIn")
        activity.userInfo = ["password": "", "username": ""]
        signInButton.userActivity = activity
        return signInButton
    }()
    
    lazy var signUpButton : UIButton = {
        let signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("or create an account", for: .normal)
        signUpButton.setTitleColor(.lightGray, for: .normal)
        signUpButton.addTarget(self.vc, action: #selector(self.vc?.signUpButtonPressed), for: .touchUpInside)
        return signUpButton
    }()
    
    let incorrectSignInLabel : UILabel = {
        let incorrectSignInLabel = UILabel()
        incorrectSignInLabel.textColor = .red
        incorrectSignInLabel.translatesAutoresizingMaskIntoConstraints = false
        incorrectSignInLabel.isHidden = true
        return incorrectSignInLabel
    }()
    
    weak var vc: SignInViewController?

    init(vc: SignInViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        
        self.addSubview(self.incorrectSignInLabel)
        self.addSubview(self.usernameTextField)
        self.addSubview(self.passwordTextField)
        self.addSubview(self.signInButton)
        self.addSubview(self.signUpButton)
        
        self.createConstraints(item: self.incorrectSignInLabel, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 - Double(self.bounds.height) * 9 / 20)
        self.createConstraints(item: self.usernameTextField, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 - Double(self.bounds.height) * 2 / 5)
        self.createConstraints(item: self.passwordTextField, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 - Double(self.bounds.height) * 3 / 10)
        self.createConstraints(item: self.signInButton, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 + Double(self.bounds.height) / 10)
        self.createConstraints(item: self.signUpButton, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 +  Double(self.bounds.height) * 3 / 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayEmptyUsernameOrPasswordError() {
        self.incorrectSignInLabel.text = "Please fill out username and password fields."
        self.incorrectSignInLabel.isHidden = false
    }
    
    func displayIncorrectUsernameOrPasswordError() {
        self.incorrectSignInLabel.text = "Incorrect username or password"
        self.incorrectSignInLabel.isHidden = false
    }

    func createConstraints(item: UIView, distFromLeft: Double, distFromTop: Double)
    {
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: distFromTop),
            item.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: distFromLeft),
            item.heightAnchor.constraint(equalToConstant: 40),
            item.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }
}

extension SignInView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            
            self.signInButton.userActivity?.userInfo?["password"] =  self.passwordTextField.text
            self.signInButton.userActivity?.userInfo?["username"] =  self.usernameTextField.text
            
            self.vc?.signInButtonPressed(sender: signInButton)
        }
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case passwordTextField:
            self.signInButton.userActivity?.userInfo?["password"] = textField.text
        default:
            self.signInButton.userActivity?.userInfo?["username"] = textField.text
        }
        incorrectSignInLabel.isHidden = true
    }
}
