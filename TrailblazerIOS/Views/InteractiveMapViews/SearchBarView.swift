//
//  SearchBarView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/16/23.
//

import Foundation
import UIKit

final class SearchBarTableHeaderView: UIView {
    let destinationTextField : UITextField = {
        let destinationTextField = UITextField()
        destinationTextField.placeholderRect(forBounds: destinationTextField.bounds)
        destinationTextField.placeholder = "Enter Destination"
        destinationTextField.backgroundColor = UIColor(hex: "#dddddd70")
        destinationTextField.layer.cornerRadius = 10
        return destinationTextField
    }()
    
    let originTextField : UITextField = {
        let originTextField = UITextField()
        originTextField.placeholderRect(forBounds: originTextField.bounds)
        originTextField.placeholder = "Origin: Your Location..."
        originTextField.backgroundColor = UIColor(hex: "#dddddd70")
        originTextField.layer.cornerRadius = 10
        originTextField.isHidden = true
        return originTextField
    }()
    
    lazy var searchButton : UIButton = {
        let searchButton = UIButton(frame: CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40))
        searchButton.tintColor = .white
        searchButton.setImage(searchImageView.image, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return searchButton
    }()
    
    lazy var directionsButton : UIButton = {
        let directionsButton = UIButton(frame: CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40))
        directionsButton.isHidden = true
        directionsButton.tintColor = .white
        directionsButton.setImage(directionsImageView.image, for: .normal)
        directionsButton.addTarget(self, action: #selector(directionsButtonPressed), for: .touchUpInside)
        return directionsButton
    }()
    
    let searchImageView : UIImageView = {
        let searchImageView = UIImageView()
        searchImageView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        searchImageView.image = UIImage(systemName: "magnifyingglass")!
        return searchImageView
    }()
    
    let directionsImageView : UIImageView = {
        let directionsImageView = UIImageView()
        directionsImageView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        directionsImageView.image = UIImage(systemName: "eye.circle")!
        return directionsImageView
    }()
    
    lazy var leftBackgroundView : UIView = {
        let leftBackgroundView = UIView(frame: CGRect(x: self.bounds.width - 40, y: 0, width: 30, height: self.bounds.height))
        leftBackgroundView.layer.cornerRadius = 10
        leftBackgroundView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        return leftBackgroundView
    }()
    
    let rightBackgroundView : UIView = {
        let rightBackgroundView = UIView()
        rightBackgroundView.backgroundColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        rightBackgroundView.layer.cornerRadius = 10
        return rightBackgroundView
    }()
    
    var initialFrame: CGRect
    var extendedFrame: CGRect
    var droppedDownFrame : CGRect
    var isExtended = false
    var isDroppedDown = false
    
    
    init(frame: CGRect, extendedFrame: CGRect, droppedDownFrame: CGRect) {
        self.initialFrame = frame
        self.extendedFrame = extendedFrame
        self.droppedDownFrame = droppedDownFrame
        super.init(frame: frame)
        self.setInitialFrame()
        self.reloadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInitialFrame()
    {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = .init(red: 0.8, green: 0, blue: 0.03, alpha: 1)
        
        self.addSubview(destinationTextField)
        self.addSubview(originTextField)
        self.addSubview(rightBackgroundView)
        self.addSubview(leftBackgroundView)
        self.addSubview(searchButton)
        self.addSubview(directionsButton)
    }
    
    func reloadView() {
        
        originTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height/2)
        
        rightBackgroundView.frame = CGRect(x: self.bounds.width - 20, y: 0, width: 20, height: self.bounds.height)
    }
    
    func presentExtendedView(){
        self.isExtended = true
        self.leftBackgroundView.layer.cornerRadius = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.extendedFrame
            self.reloadView()
            self.searchButton.frame = CGRect(x: self.bounds.width-80, y: 0, width: 40, height: 40)
            self.directionsButton.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 40, height: 40)
            self.leftBackgroundView.frame = CGRect(x: self.bounds.width - 80, y: 0, width: 70, height: self.bounds.height)
            self.destinationTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height)
            self.directionsButton.isHidden = false
        }, completion: nil)
    }
    
    func dismissExtendedView()
    {
        self.destinationTextField.endEditing(true)
        self.originTextField.endEditing(true)
        self.isExtended = false
        self.leftBackgroundView.layer.cornerRadius = 10
        self.directionsButton.isHidden = true
        self.isDroppedDown = false
        self.originTextField.isHidden = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.initialFrame
            self.reloadView()
            self.searchButton.frame = CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40)
            self.directionsButton.frame = CGRect(x: self.bounds.width-40, y: 0, width: 40, height: 40)
            self.leftBackgroundView.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 30, height: self.bounds.height)
            self.destinationTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height)
        }, completion: nil)
    }
    
    func presentDropDownView()
    {
        self.originTextField.isHidden = false
        self.isDroppedDown = true
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.droppedDownFrame
            self.reloadView()
            self.searchButton.frame = CGRect(x: self.bounds.width-80, y: self.bounds.height/4, width: 40, height: 40)
            self.directionsButton.frame = CGRect(x: self.bounds.width - 40, y: self.bounds.height/4, width: 40, height: 40)
            self.leftBackgroundView.frame = CGRect(x: self.bounds.width - 80, y: 0, width: 70, height: self.bounds.height)
            self.destinationTextField.frame = CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width - 40, height: self.bounds.height/2)
        }, completion: nil)
    }
    
    func dismissDropDownView()
    {
        self.originTextField.endEditing(true)
        self.originTextField.isHidden = true
        self.isDroppedDown = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.frame = self.extendedFrame
            self.reloadView()
            self.searchButton.frame = CGRect(x: self.bounds.width-80, y: 0, width: 40, height: 40)
            self.directionsButton.frame = CGRect(x: self.bounds.width - 40, y: 0, width: 40, height: 40)
            self.leftBackgroundView.frame = CGRect(x: self.bounds.width - 80, y: 0, width: 70, height: self.bounds.height)
            self.destinationTextField.frame = CGRect(x: 0, y: 0, width: self.bounds.width - 40, height: self.bounds.height)
            
        }, completion: nil)
    }
    
    @objc func searchButtonPressed()
    {
        if !isExtended
        {
            self.presentExtendedView()
        }
        else
        {
            self.dismissExtendedView()
        }
    }
    
    @objc func directionsButtonPressed()
    {
        if !isDroppedDown
        {
            presentDropDownView()
        }
        else
        {
            dismissDropDownView()
        }
    }
}
