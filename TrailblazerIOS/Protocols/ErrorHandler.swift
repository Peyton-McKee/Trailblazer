//
//  ErrorHandler.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/14/23.
//

import Foundation
import UIKit

protocol ErrorHandler {
    func handle(error: Error)
}

extension ErrorHandler where Self: UIViewController {
    func handle(error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
