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
    
    var incorrectSignInLabel = UILabel()
    
    static var currentUser = User(userName: "", password: "")
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
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Enter Password..."
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = .lightGray
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.autocorrectionType = .no
        
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
        getUsers(completion: { value in
            guard let users = try? value.get() else
            {
                print("Error: \(value)")
                return
            }
            let myUser = User(userName: usernameText, password: passwordText)
            var foundMatch = false
            for user in users
            {
                if user.userName == myUser.userName && user.password == myUser.password
                {
                    let userIdString = user.id!
                    foundMatch = true
                    InteractiveMapViewController.currentUser = user
                    self.navigationController?.show(InteractiveMapViewController(), sender: sender)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    UserDefaults.standard.set("\(user.userName)", forKey: "userUsername")
                    UserDefaults.standard.set("\(user.password)", forKey: "userPassword")
                    UserDefaults.standard.set("\(userIdString)", forKey: "userId")
                    // This is to get the SceneDelegate object from your view controller
                    // then call the change root view controller function to change to main tab bar
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                    //you have successfully logged in
                    break
                }
            }
            if !foundMatch
            {
                self.incorrectSignInLabel.text = "Incorrect Username or Password"
                self.incorrectSignInLabel.isHidden = false
            }
        })
    }
    @objc func signUpButtonPressed(sender: UIButton)
    {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: "http://127.0.0.1:8080/api/users")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            let decoder = JSONDecoder()
            if let users = try? decoder.decode([User].self, from: data) {
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } else {
                print("Unable to parse JSON response.")
                completion(.failure(error!))
            }
        }.resume()
        
    }
}

extension SignInViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if( textField == passwordTextField)
        {
            signInButtonPressed(sender: signUpButton)
        }
        return true
    }
    
}
