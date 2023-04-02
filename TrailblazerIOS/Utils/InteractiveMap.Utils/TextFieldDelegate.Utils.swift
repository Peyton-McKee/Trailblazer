//
//  TextFieldDelegate.Util.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import UIKit

extension InteractiveMapViewController: UITextFieldDelegate
{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        trailSelectorView.currentTextField = textField
        if textField.placeholder == "Origin: Your Location..."
        {
            trailSelectorView.currentTextFieldType = .origin
        }
        else {
            trailSelectorView.currentTextFieldType = .destination
        }
        if(trailSelectorView.isPresented)
        {
            return true
        }
        else
        {
            presentSideMenu()
        }
        NotificationCenter.default.post(name: Notification.Name.Names.filterTrails, object: nil, userInfo: ["searchText": textField.text as Any])
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        NotificationCenter.default.post(name: Notification.Name.Names.filterTrails, object: nil, userInfo: ["searchText": textField.text as Any])
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.wasCancelled
        {
            dismissSideMenu()
            return
        }
        else if (textField == searchBar.originTextField)
        {
            guard let firstCell = self.trailSelectorView.searchBarTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrailSelectorTableViewCell else
            {
                //then there are no trails matching the search text
                return
            }
            self.originTextFieldTrail = firstCell.cellTrail!
            self.searchBar.originTextField.text = firstCell.cellTrail?.title!
        }
        if textField == searchBar.destinationTextField && !(self.searchBar.destinationTextField.text!.isEmpty)
        {
            guard let firstCell = self.trailSelectorView.searchBarTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TrailSelectorTableViewCell else {
                //Then there are not trails matching the search text
                return
            }
            self.searchBar.destinationTextField.text = firstCell.cellTrail?.title
            self.trailSelectorMenu.dismissItems()
            self.trailSelectorView.isPresented = false
            self.reloadButtons()
            self.sampleRoute(origin: self.originTextFieldTrail, destination: firstCell.cellTrail!)
            self.originTextFieldTrail = nil
            self.searchBar.originTextField.text = nil
            self.searchBar.destinationTextField.text = nil
        }
    }
}


