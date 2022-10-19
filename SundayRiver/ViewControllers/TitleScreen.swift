//
//  ViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 3/8/22.
//

import UIKit

class TitleScreen: UIViewController{
    
    var sLabel = UILabel()
    var uLabel = UILabel()
    var nLabel = UILabel()
    var dLabel = UILabel()
    var aLabel = UILabel()
    var yLabel = UILabel()
    var rLabel = UILabel()
    var iLabel = UILabel()
    var vLabel = UILabel()
    var eLabel = UILabel()
    var r1Label = UILabel()
    var preferredFont = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .largeTitle), size: 40)
    var trailblazerLabel = UILabel()
    var signInButton = UIButton()
    var continueAsGuestButton = UIButton()
    var signUpButton = UIButton()
    var backgroundImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backgroundImageView.frame = view.frame
        backgroundImageView.image = UIImage(named: "SRSun.png")!
        view.addSubview(backgroundImageView)
        configureText()
        animateText()
        configureButtons()
        
    }
    
    func animateText()
    {
        animateLabels(label: sLabel, delay: 0.1)
        animateLabels(label: uLabel, delay: 0.15)
        animateLabels(label: nLabel, delay: 0.2)
        animateLabels(label: dLabel, delay: 0.25)
        animateLabels(label: aLabel, delay: 0.3)
        animateLabels(label: yLabel, delay: 0.35)
        animateLabels(label: rLabel, delay: 0.1)
        animateLabels(label: iLabel, delay: 0.15)
        animateLabels(label: vLabel, delay: 0.2)
        animateLabels(label: eLabel, delay: 0.25)
        animateLabels(label: r1Label, delay: 0.3)
        animateTrailBlazer()
    }
    
    func configureText()
    {
        sLabel.text = "S"
        sLabel.translatesAutoresizingMaskIntoConstraints = false
        sLabel.font = preferredFont
        sLabel.textColor = .red
        uLabel.text = "u"
        uLabel.translatesAutoresizingMaskIntoConstraints = false
        uLabel.font = preferredFont
        uLabel.textColor = .red
        nLabel.text = "n"
        nLabel.translatesAutoresizingMaskIntoConstraints = false
        nLabel.font = preferredFont
        nLabel.textColor = .red

        dLabel.text = "d"
        dLabel.translatesAutoresizingMaskIntoConstraints = false
        dLabel.font = preferredFont
        dLabel.textColor = .red

        aLabel.text = "a"
        aLabel.translatesAutoresizingMaskIntoConstraints = false
        aLabel.font = preferredFont
        aLabel.textColor = .red

        yLabel.text = "y"
        yLabel.translatesAutoresizingMaskIntoConstraints = false
        yLabel.font = preferredFont
        yLabel.textColor = .red

        rLabel.text = "R"
        rLabel.translatesAutoresizingMaskIntoConstraints = false
        rLabel.font = preferredFont
        rLabel.textColor = .red

        iLabel.text = "i"
        iLabel.translatesAutoresizingMaskIntoConstraints = false
        iLabel.font = preferredFont
        iLabel.textColor = .red

        vLabel.text = "v"
        vLabel.translatesAutoresizingMaskIntoConstraints = false
        vLabel.font = preferredFont
        vLabel.textColor = .red

        eLabel.text = "e"
        eLabel.translatesAutoresizingMaskIntoConstraints = false
        eLabel.font = preferredFont
        eLabel.textColor = .red

        r1Label.text = "r"
        r1Label.translatesAutoresizingMaskIntoConstraints = false
        r1Label.font = preferredFont
        r1Label.textColor = .red

        trailblazerLabel.text = "Trailblazer"
        trailblazerLabel.translatesAutoresizingMaskIntoConstraints = false
        trailblazerLabel.font = preferredFont
        trailblazerLabel.alpha = 0
        trailblazerLabel.textColor = .red

        
        self.view.addSubview(sLabel)
        self.view.addSubview(uLabel)
        self.view.addSubview(nLabel)
        self.view.addSubview(dLabel)
        self.view.addSubview(aLabel)
        self.view.addSubview(yLabel)
        self.view.addSubview(rLabel)
        self.view.addSubview(iLabel)
        self.view.addSubview(vLabel)
        self.view.addSubview(eLabel)
        self.view.addSubview(r1Label)
        self.view.addSubview(trailblazerLabel)
        
        createConstraints(item: sLabel, distFromLeft: Double(view.bounds.width)/2 - 123, distFromTop: 80)
        createConstraints(item: uLabel, distFromLeft: Double(view.bounds.width)/2 - 100, distFromTop: 80)
        createConstraints(item: nLabel, distFromLeft: Double(view.bounds.width)/2 - 80, distFromTop: 80)
        createConstraints(item: dLabel, distFromLeft: Double(view.bounds.width)/2 - 60, distFromTop: 80)
        createConstraints(item: aLabel, distFromLeft: Double(view.bounds.width)/2 - 40, distFromTop: 80)
        createConstraints(item: yLabel, distFromLeft: Double(view.bounds.width)/2 - 20, distFromTop: 80)
        createConstraints(item: rLabel, distFromLeft: Double(view.bounds.width)/2 - 50, distFromTop: 120)
        createConstraints(item: iLabel, distFromLeft: Double(view.bounds.width)/2 - 26, distFromTop: 120)
        createConstraints(item: vLabel, distFromLeft: Double(view.bounds.width)/2 - 18, distFromTop: 120)
        createConstraints(item: eLabel, distFromLeft: Double(view.bounds.width)/2 + 2, distFromTop: 120)
        createConstraints(item: r1Label, distFromLeft: Double(view.bounds.width)/2 + 22, distFromTop: 120)
        createConstraints(item: trailblazerLabel, distFromLeft: Double(view.bounds.width)/2 - 100, distFromTop: 160)

    }
    func configureButtons()
    {
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.backgroundColor = .cyan
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.titleLabel!.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 20)
        signInButton.addTarget(self, action: #selector(toSignIn), for: .touchUpInside)
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.backgroundColor = .lightGray
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.titleLabel!.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 20)
        signUpButton.addTarget(self, action: #selector(toSignUp), for: .touchUpInside)
        
        continueAsGuestButton.setTitle("or continue as guest", for: .normal)
        continueAsGuestButton.setTitleColor(.white, for: .normal)
        continueAsGuestButton.addTarget(self, action: #selector(toInteractiveMap), for: .touchUpInside)
        continueAsGuestButton.translatesAutoresizingMaskIntoConstraints = false
        continueAsGuestButton.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        continueAsGuestButton.titleLabel!.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 20)
        

        view.addSubview(signInButton)
        view.addSubview(continueAsGuestButton)
        view.addSubview(signUpButton)
        
        createConstraints(item: signInButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height)/5)
        createConstraints(item: signUpButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) * 5/20)
        createConstraints(item: continueAsGuestButton, distFromLeft: 0, distFromTop: Double(view.bounds.height)/2 + Double(view.bounds.height) * 6/20)
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
    
    func animateLabels(label: UILabel, delay: Double)
    {
        UIView.animate(withDuration: 2, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
            
            label.center = CGPoint(x: label.center.x, y: label.center.y + 20)
            
        }, completion: nil)
    }
    func animateTrailBlazer()
    {
        UIView.animate(withDuration: 2, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
            
            self.trailblazerLabel.alpha = 1
            
        }, completion: nil)
    }
    
    @objc func toSignIn(sender: UIButton!)
    {
        self.navigationController?.show(SignInViewController(), sender: sender)
    }
    
    @objc func toInteractiveMap(sender: UIButton!)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
            
            // This is to get the SceneDelegate object from your view controller
            // then call the change root view controller function to change to main tab bar
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        InteractiveMapViewController.currentUser = User(userName: "Guest", password: "")
    }
    @objc func toSignUp(sender: UIButton!)
    {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}

