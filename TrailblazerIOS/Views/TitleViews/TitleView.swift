//
//  TitleView.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/12/23.
//

import Foundation
import UIKit

final class TitleView : UIView {

    lazy var trailblazerLabel : UILabel = {
        let trailblazerLabel = UILabel()
        trailblazerLabel.text = "Trailblazer"
        trailblazerLabel.translatesAutoresizingMaskIntoConstraints = false
        trailblazerLabel.font = .Theme.markerFelt?.withSize(40)
        trailblazerLabel.alpha = 0
        trailblazerLabel.textColor = .white
        return trailblazerLabel
    }()

    lazy var signInButton : UIButton = {
        let signInButton = UIButton()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.titleLabel?.font = .Theme.markerFelt
        signInButton.backgroundColor = .cyan
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self.vc, action: #selector(self.vc?.signInOrSignUp), for: .touchUpInside)
        return signInButton
    }()

    lazy var continueAsGuestButton : UIButton = {
        let continueAsGuestButton = UIButton()
        continueAsGuestButton.setTitle("or continue as guest", for: .normal)
        continueAsGuestButton.setTitleColor(.white, for: .normal)
        continueAsGuestButton.addTarget(self.vc, action: #selector(self.vc?.toInteractiveMap), for: .touchUpInside)
        continueAsGuestButton.translatesAutoresizingMaskIntoConstraints = false
        continueAsGuestButton.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        continueAsGuestButton.titleLabel!.font = .Theme.markerFelt
        return continueAsGuestButton
    }()

    lazy var signUpButton : UIButton = {
        let signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .lightGray
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.titleLabel!.font = .Theme.markerFelt
        signUpButton.addTarget(self.vc, action: #selector(self.vc?.signInOrSignUp), for: .touchUpInside)
        return signUpButton
    }()
    
    lazy var backgroundImageView : UIImageView = {
        let backgroundImageView = UIImageView(frame: self.frame)
        backgroundImageView.image = UIImage(named: "SRSun.png")!
        return backgroundImageView
    }()
    
    weak var vc : TitleViewController?

    init(vc: TitleViewController) {
        self.vc = vc
        super.init(frame: vc.view.frame)
        self.backgroundColor = .white

        self.addSubview(self.backgroundImageView)
        self.addSubview(self.trailblazerLabel)
        self.addSubview(self.signInButton)
        self.addSubview(self.continueAsGuestButton)
        self.addSubview(self.signUpButton)
        
        self.createConstraints(item: self.trailblazerLabel, distFromLeft: Double(self.bounds.width)/2 - 100, distFromTop: 160)
        self.createConstraints(item: self.signInButton, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 + Double(self.bounds.height)/5)
        self.createConstraints(item: self.signUpButton, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 + Double(self.bounds.height) * 5/20)
        self.createConstraints(item: self.continueAsGuestButton, distFromLeft: 0, distFromTop: Double(self.bounds.height)/2 + Double(self.bounds.height) * 6/20)
        
        self.animateTrailBlazer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("title view deinitialized")
    }
    
    func createConstraints(item: UIView, distFromLeft: Double, distFromTop: Double)
    {
        NSLayoutConstraint.activate([
            item.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: distFromTop),
            item.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: distFromLeft),
            item.heightAnchor.constraint(equalToConstant: 40),
            item.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
        ])
    }

    func animateTrailBlazer()
    {
        UIView.animate(withDuration: 4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
            self.trailblazerLabel.alpha = 1
        }, completion: nil)
    }
}
