//
//  MoreSettingsViewController.swift
//  Trailblazer
//
//  Created by Peyton McKee on 12/24/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers


class MoreSettingViewController: UIViewController, ErrorHandler {
    var mapFile: String?
    
    lazy var moreSettingsView = MoreSettingsView(vc: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(moreSettingsView)
    }
    
    @objc func selectFiles() {
        let supportedTypes: [UTType] = [UTType.xml]
        let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        pickerViewController.delegate = self
        pickerViewController.allowsMultipleSelection = false
        pickerViewController.shouldShowFileExtensions = true
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    @objc func submitFiles(sender: UIButton) {
        guard let mapFile = mapFile, let link = sender.userActivity?.userInfo?["link"] as? String else {
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
            do {
                _ = try result.get()
            } catch {
                DispatchQueue.main.async {
                    self.handle(error: error)
                }
            }
        })
    }

    @objc func logOutPressed(sender: UIButton)
    {
        UserDefaults.standard.removeObject(forKey: "userUsername")
        UserDefaults.standard.removeObject(forKey: "userPassword")
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "alertSettings")
        UserDefaults.standard.removeObject(forKey: "routingPreference")
        UserDefaults.standard.removeObject(forKey: "mapId")
        InteractiveMapViewController.currentUser = User(username: "Guest", password: "", alertSettings: [], routingPreference: "")
        NotificationCenter.default.post(Notification(name: Notification.Name.Names.cancelRoute))
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginNavController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginNavController)
    }
}


