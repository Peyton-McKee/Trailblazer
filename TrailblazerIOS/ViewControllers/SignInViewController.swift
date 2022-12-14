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
    var userNameTextField = UITextField()
    var passwordTextField = UITextField()
    var signInButton = UIButton()
    var signUpButton = UIButton()
    let baseURL = "http://35.172.135.117"
    var incorrectSignInLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureTextFields()
        configureButtons()
        configureLabels()
    }
    
    func configureLabels()
    {
        incorrectSignInLabel.textColor = .red
        incorrectSignInLabel.translatesAutoresizingMaskIntoConstraints = false
        incorrectSignInLabel.isHidden = true
        view.addSubview(incorrectSignInLabel)
        createConstraints(item: incorrectSignInLabel, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 - Double(view.bounds.height) * 9 / 20)
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
        
        view.addSubview(userNameTextField)
        view.addSubview(passwordTextField)
        
        createConstraints(item: userNameTextField, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 - Double(view.bounds.height) * 2 / 5)
        createConstraints(item: passwordTextField, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 - Double(view.bounds.height) * 3 / 10)
    }
    func configureButtons()
    {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Continue", for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.backgroundColor = .cyan
        signInButton.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("or create an account", for: .normal)
        signUpButton.setTitleColor(.lightGray, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        createConstraints(item: signInButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) / 10)
        createConstraints(item: signUpButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 +  Double(view.bounds.height) * 3 / 20)
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
    @objc func signInButtonPressed(sender: UIButton)
    {
        guard let usernameText = userNameTextField.text, let passwordText = passwordTextField.text else {
            //say please fill out username and password information
            return
        }
        loginHandler(username: usernameText, password: passwordText, completion: {
            result in
            guard let user = try? result.get() else
            {
                print(result)
                return
            }
            InteractiveMapViewController.currentUser = user
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
            UserDefaults.standard.set("\(user.username)", forKey: "userUsername")
            UserDefaults.standard.set(user.alertSettings, forKey: "alertSettings")
            UserDefaults.standard.set("\(user.routingPreference)", forKey: "routingPreference")
            UserDefaults.standard.set("\(user.id!)", forKey: "userId")
        })
    }
    @objc func signUpButtonPressed(sender: UIButton)
    {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
}

extension SignInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            signInButtonPressed(sender: signInButton)
        }
        return false
    }
    
}
