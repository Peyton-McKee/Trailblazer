//
//  SignUpViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/4/22.
//

import Foundation
import UIKit

class SignUpViewController : UIViewController {
    var userNameTextField = UITextField()
    var passwordTextField = UITextField()
    var confirmPasswordTextField = UITextField()
    let baseURL = getBaseUrl()
    var incorrectSignUpLabel = UILabel()
    
    var signInButton = UIButton()
    var signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureTextFields()
        configureButtons()
        configureLabels()
    }
    
    func configureLabels()
    {
        incorrectSignUpLabel.translatesAutoresizingMaskIntoConstraints = false
        incorrectSignUpLabel.isHidden = true
        incorrectSignUpLabel.textColor = .red
        view.addSubview(incorrectSignUpLabel)
        createConstraints(item: incorrectSignUpLabel, distFromLeft: 0, distFromTop:   Double(view.bounds.height)/2 - Double(view.bounds.height) *  9 / 20)
        
    }
    func configureTextFields()
    {
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.placeholder = "Enter Username..."
        userNameTextField.delegate = self
        userNameTextField.backgroundColor = .lightGray
        userNameTextField.autocapitalizationType = .none
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.autocorrectionType = .no
        userNameTextField.tag = 1
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Enter Password..."
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = .lightGray
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocorrectionType = .no
        passwordTextField.tag = 2
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.placeholder = "Confirm Password..."
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.backgroundColor = .lightGray
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.tag = 3
        
        view.addSubview(userNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        
        createConstraints(item: userNameTextField, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 - Double(view.bounds.height) * 2 / 5)
        createConstraints(item: passwordTextField, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 - Double(view.bounds.height) * 3 / 10)
        createConstraints(item: confirmPasswordTextField, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 - Double(view.bounds.height) / 5)
    }
    func configureButtons()
    {
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Continue", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .cyan
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Already have an account? Sign In...", for: .normal)
        signInButton.setTitleColor(.lightGray, for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        createConstraints(item: signUpButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 10)
        createConstraints(item: signInButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 +  Double(view.bounds.height) * 3 / 20)
    }
    func createConstraints(item: UIView, distFromLeft: Double, distFromTop: Double)
    {
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: distFromTop),
            item.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: distFromLeft),
            item.heightAnchor.constraint(equalToConstant: 40),
            item.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    @objc func signUpButtonPressed(sender: UIButton)
    {
        guard let usernameText = userNameTextField.text, let passwordText = passwordTextField.text, let confirmPasswordText = confirmPasswordTextField.text else {
            return //display text saying fill out all forms
        }
        if passwordText != confirmPasswordText
        {
            self.incorrectSignUpLabel.text = "Passwords Do Not Match"
            self.incorrectSignUpLabel.isHidden = false
            return //display text saying passwords do not match
        }
        print(passwordText)
        saveUser(User(username: usernameText, password: passwordText, alertSettings: [], routingPreference: RoutingType.easiest.rawValue), completion: {
            value in
            guard let user = try? value.get() else
            {
                DispatchQueue.main.async{
                    self.incorrectSignUpLabel.text = "Username Already Taken"
                    self.incorrectSignUpLabel.isHidden = false
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

extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            signUpButtonPressed(sender: signUpButton)
        }
        return false
    }
    
}

