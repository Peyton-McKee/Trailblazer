//
//  UserTrailReportsViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 10/25/22.
//

import Foundation
import UIKit

class UserTrailReportsViewController: UIViewController{
    
    lazy var userTrailReportsView = UserTrailReportsView(frame: self.view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(userTrailReportsView)
        self.getUsersTrailReports()
    }

    private func getUsersTrailReports()
    {
        guard let currentUserId = InteractiveMapViewController.currentUser.id else {
            //user is a guest
            return
        }
        APIHandler.shared.getSingleUserTrailReports(id: currentUserId, completion: { result in
            guard let userTrailReports = try? result.get() else {
                print("Error: \(result)")
                return
            }
            self.userTrailReportsView.displayTrailReports(trailReports: userTrailReports)
        })
    }
}
