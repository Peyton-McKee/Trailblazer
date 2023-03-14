//
//  MoreSettingsTextFieldDelegate.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/14/23.
//

import Foundation
import UIKit

extension MoreSettingsView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.submitButton.userActivity?.userInfo?["link"] = textField.text
    }
}
