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
    lazy var pageVStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        [titleLabel.self, formVStack.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    lazy var formVStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.layer.cornerRadius = 8
        stackView.layer.shadowRadius = 8
        stackView.layer.shadowOffset = .zero
        stackView.layer.shadowOpacity = 0.5
        stackView.layer.shadowColor = UIColor(hex: "#ffffffff")?.cgColor
        stackView.layer.backgroundColor = UIColor(hex: "#ae82f2a7")?.cgColor
        [entryHStack.self, submitButton.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Upload or edit a map"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var entryHStack : UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        [selectAFileButton.self, linkTextField.self].forEach({stackView.addArrangedSubview($0)})
        return stackView
    }()
    
    lazy var selectAFileButton: UIButton = {
        var button = UIButton()
        button.setTitle("Upload a Map File", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .myTheme.liftsColor
        button.addTarget(self, action: #selector(selectFiles), for: .touchUpInside)
        return button
    }()
    lazy var linkTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = UIColor(hex: "#232323ff")
        textField.layer.cornerRadius = 15
        textField.placeholder = "Enter link for mountain report..."
        textField.delegate = self
        return textField
    }()
    
    lazy var submitButton: UIButton = {
       var button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .myTheme.easyColor
        button.addTarget(self, action: #selector(submitFiles), for: .touchUpInside)
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(pageVStack)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height/5),
            pageVStack.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            pageVStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageVStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            submitButton.trailingAnchor.constraint(equalTo: pageVStack.trailingAnchor)
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
        guard let mapFile = mapFile else {
            return
        }
        let start = mapFile.index(of: "<name>")
        let end = mapFile.suffix(from: start!).index(of: "<name>")
        let title = String(mapFile.suffix(from: start!).prefix(upTo: end!))
        saveMapFile(mapFile: MapFile(title: title, file: mapFile), completion: {
            result in
            guard let mapFile = try? result.get() else {
                return
            }
            print(mapFile)
        })
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

