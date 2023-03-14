//
//  Notification.Utils.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation

extension InteractiveMapViewController {
    @objc func createNotification(sender: NSNotification)
    {
        guard let trailReport = sender.userInfo?["report"] as? TrailReport else
        {
            print("NotiAnnotation configured incorrectly or does not exist")
            return
        }
        LocationManager.shared.makeTrailReportRegion(trailReport: trailReport)
        LocationManager.shared.registerNotification(title: "CAUTION: \(trailReport.type.uppercased()) AHEAD", body: trailReport.type, trailReportID: trailReport.id!)
    }
}
