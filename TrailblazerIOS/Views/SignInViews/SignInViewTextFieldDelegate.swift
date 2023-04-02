//
//  SignInViewTextFieldDelegate.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/13/23.
//

import Foundation
import UIKit

extension SignInView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            
            self.signInButton.userActivity?.userInfo?["password"] = self.passwordTextField.text
            self.signInButton.userActivity?.userInfo?["username"] = self.usernameTextField.text
            
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
        self.incorrectSignInLabel.isHidden = true
    }
}
