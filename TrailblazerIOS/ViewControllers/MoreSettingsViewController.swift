//
//  MoreSettingsViewController.swift
//  Trailblazer
//
//  Created by Peyton McKee on 12/24/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers


class MoreSettingViewController: UIViewController
{
    var mapFile: String?

    lazy var logOutButton : UIButton = {
        var button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont(name: "markerfelt-wide", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .myTheme.intermediateColor
        button.addTarget(self, action: #selector(logOutPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var moreSettingsLabel : UILabel = {
        var label = UILabel()
        label.text = "More Settings"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pageVStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        [moreSettingsLabel.self, formVStack.self, logOutButton.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    lazy var formVStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.layer.shadowRadius = 8
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowOpacity = 0.5
        stackView.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        stackView.layer.backgroundColor = UIColor.white.cgColor
        stackView.layer.borderColor = UIColor.darkGray.cgColor
        stackView.layer.borderWidth = 1
        [titleLabel.self, entryHStack.self, submitButton.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Upload or edit a map"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.backgroundColor = UIColor.gray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    lazy var entryHStack : UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        [selectAFileButton.self, linkTextField.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    lazy var selectAFileButton: UIButton = {
        var button = UIButton()
        button.setTitle("Choose File", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(selectFiles), for: .touchUpInside)
        return button
    }()
    lazy var linkTextField: UITextField = {
        var textField = UITextField()
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "Enter link for mountain report..."
        textField.delegate = self
        return textField
    }()
    
    lazy var submitButton: UIButton = {
       var button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .myTheme.easyColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(submitFiles), for: .touchUpInside)
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(pageVStack)
        NSLayoutConstraint.activate([
            moreSettingsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * (3/20)),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            pageVStack.topAnchor.constraint(equalTo: moreSettingsLabel.topAnchor),
            pageVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc func selectFiles() {
        let supportedTypes: [UTType] = [UTType.xml]
        let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        pickerViewController.delegate = self
        pickerViewController.allowsMultipleSelection = false
        pickerViewController.shouldShowFileExtensions = true
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    @objc func submitFiles() {
        guard let mapFile = mapFile, let link = linkTextField.text else {
            //say invalid entry
            return
        }
        guard let start = mapFile.index(of: "<name>") else {
            //Invalid Entry
            return
        }
        let end = mapFile.suffix(from: start).index(of: "<name>")
        let title = String(mapFile.suffix(from: start).prefix(upTo: end!))
        APIHandler.shared.saveMapFile(mapFile: MapFile(title: title, file: mapFile, link: link), completion: {
            result in
            guard let mapFile = try? result.get() else {
                return
            }
            print(mapFile)
        })
    }
    @objc func logOutPressed(sender: UIButton)
    {
        UserDefaults.standard.removeObject(forKey: "userUsername")
        UserDefaults.standard.removeObject(forKey: "userPassword")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "alertSettings")
        UserDefaults.standard.removeObject(forKey: "routingPreference")
        InteractiveMapViewController.currentUser = User(username: "Guest", password: "", alertSettings: [], routingPreference: "")
        NotificationCenter.default.post(Notification(name: Notification.Name.Names.cancelRoute))
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}

extension MoreSettingViewController: UIDocumentPickerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        do {
            let data = try String(contentsOf: myURL)
            print(data)
            mapFile = data
        }
        catch{
            print("Could not get contents of file")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
    
}

