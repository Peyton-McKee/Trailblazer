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
    
    var signInButton = UIButton()
    var signUpButton = UIButton()
    
    var url = URL(string: "http://127.0.0.1:8080")!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTextFields()
        configureButtons()
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
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.placeholder = "Confirm Password..."
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.backgroundColor = .lightGray
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.autocorrectionType = .no
        
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
            return //display text saying passwords do not match
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
                if user.userName == myUser.userName
                {
                    foundMatch = true
                    //say this username has been taken
                    break
                }
            }
            if !foundMatch {
                self.saveUser(myUser)
                InteractiveMapViewController.currentUser = myUser
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                
                // This is to get the SceneDelegate object from your view controller
                // then call the change root view controller function to change to main tab bar
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                //say user successfully created
            }
        })
    }
    @objc func signInButtonPressed(sender: UIButton)
    {
        self.navigationController?.show(SignInViewController(), sender: sender)
    }
    
    func saveUser(_ user: User) {
        let url = URL(string: "http://localhost:8080/api/users")!
        
        let encoder = JSONEncoder()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? encoder.encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                if let item = try? decoder.decode(User.self, from: data) {
                    print(item.userName)
                } else {
                    print("Bad JSON received back.")
                    print(data)
                }
            }
        }.resume()
    }
    
    
    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let url = URL(string: "http://localhost:8080/api/users")!
        
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

extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if( textField == confirmPasswordTextField)
        {
            signUpButtonPressed(sender: signUpButton)
        }
        return true
    }
    
}
