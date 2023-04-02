//
//  SignUpView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/13/23.
//

import Foundation
import UIKit

final class SignUpView: UIView {
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
    
    lazy var confirmPasswordTextField : UITextField = {
        let confirmPasswordTextField = UITextField()
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.placeholder = "Confirm Password..."
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.backgroundColor = .lightGray
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.tag = 3
        return confirmPasswordTextField
    }()
        
    let incorrectSignUpLabel : UILabel = {
        let incorrectSignUpLabel = UILabel()
        incorrectSignUpLabel.translatesAutoresizingMaskIntoConstraints = false
        incorrectSignUpLabel.isHidden = true
        incorrectSignUpLabel.textColor = .red
        return incorrectSignUpLabel
    }()
    
    lazy var signInButton : UIButton = {
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Already have an account? Sign In...", for: .normal)
        signInButton.setTitleColor(.lightGray, for: .normal)
        signInButton.addTarget(self.vc, action: #selector(self.vc?.signInButtonPressed), for: .touchUpInside)
        return signInButton
    }()
    
    lazy var signUpButton : UIButton = {
        let signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Continue", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .cyan
        signUpButton.addTarget(self.vc, action: #selector(self.vc?.signUpButtonPressed), for: .touchUpInside)
        let activity = NSUserActivity(activityType: "signIn")
        activity.userInfo = ["password": "", "confirmPassword": "", "username": ""]
        signUpButton.userActivity = activity
        return signUpButton
    }()
    
    weak var vc : SignUpViewController?
    
    init(vc: SignUpViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        
        self.addSubview(self.usernameTextField)
        self.addSubview(self.passwordTextField)
        self.addSubview(self.confirmPasswordTextField)
        self.addSubview(self.incorrectSignUpLabel)
        self.addSubview(self.signInButton)
        self.addSubview(self.signUpButton)
        
        self.createConstraints(item: self.usernameTextField, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 - Double(self.bounds.height) * 2 / 5)
        self.createConstraints(item: self.passwordTextField, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 - Double(self.bounds.height) * 3 / 10)
        self.createConstraints(item: self.confirmPasswordTextField, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 - Double(self.bounds.height) / 5)
        self.createConstraints(item: self.incorrectSignUpLabel, distFromLeft: 0, distFromTop:   Double(self.bounds.height)/2 - Double(self.bounds.height) *  9 / 20)
        self.createConstraints(item: self.signUpButton, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 + Double(self.bounds.height) / 10)
        self.createConstraints(item: self.signInButton, distFromLeft: 0, distFromTop:          Double(self.bounds.height)/2 +  Double(self.bounds.height) * 3 / 20)
    }
    
    deinit {
        print("Sign Up View Deinitialized")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayEmptyUsernameOrPasswordError() {
        self.incorrectSignUpLabel.text = "Please fill out username and password fields."
        self.incorrectSignUpLabel.isHidden = false
    }
    
    func displayNonMatchingPasswordsError() {
        self.incorrectSignUpLabel.text = "Passwords Do Not Match"
        self.incorrectSignUpLabel.isHidden = false
    }
    
    func displayUsernameAlreadyTakenError() {
        self.incorrectSignUpLabel.text = "Username Already Taken"
        self.incorrectSignUpLabel.isHidden = false
    }

    private func createConstraints(item: UIView, distFromLeft: Double, distFromTop: Double)
    {
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: distFromTop),
            item.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: distFromLeft),
            item.heightAnchor.constraint(equalToConstant: 40),
            item.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
