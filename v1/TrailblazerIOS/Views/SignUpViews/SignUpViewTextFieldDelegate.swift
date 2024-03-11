//
//  SignUpViewTextFieldDelegate.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/13/23.
//

import Foundation
import UIKit

extension SignUpView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else
        {
            textField.resignFirstResponder()
            self.vc?.signUpButtonPressed(sender: signUpButton)
        }
        return false
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case self.passwordTextField:
            self.signUpButton.userActivity?.userInfo?["password"] = textField.text
        case self.confirmPasswordTextField:
            self.signUpButton.userActivity?.userInfo?["confirmPassword"] = textField.text
        default:
            self.signUpButton.userActivity?.userInfo?["username"] = textField.text
        }
        self.incorrectSignUpLabel.isHidden = true
    }
}

