//
//  LocationManager.swift
//  SundayRiver
//
//  Created by Peyton McKee on 11/8/22.
//

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject {
    let notificationCenter = UNUserNotificationCenter.current()
    var trailReportRegion : CLCircularRegion?
    
    // 1
    var locationManager = CLLocationManager()
    
    // 1
    func makeTrailReportRegion(trailReport: TrailReport) {
        // 2
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: trailReport.latitude, longitude: trailReport.longitude),
            radius: 75,
            identifier: UUID().uuidString)
        // 3
        region.notifyOnEntry = true
        // 4
        trailReportRegion = region
    }
    func unregesterNotification(for categoryIdentifier: String)
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.content.categoryIdentifier == categoryIdentifier {
                  identifiers.append(notification.identifier)
               }
           }
           UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    // 1
    func registerNotification(title: String, body: String, trailReportID: String) {
        // 2
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default
        notificationContent.userInfo = ["TRAIL_REPORT": trailReportID]
        notificationContent.categoryIdentifier = body
        
        // 3
        let trigger = UNLocationNotificationTrigger(region: trailReportRegion!, repeats: false)
        // 4
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger)
        
        // 5
        notificationCenter
            .add(request) { error in
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
            }
        
    }
    
    // 1
    override init() {
        super.init()
        // 2
        notificationCenter.delegate = self
        let confirmAction = UNNotificationAction(identifier: "CONFIRM_ACTION", title: "Confirm", options: [])
        let noLongerThereAction = UNNotificationAction(identifier: "NOLONGERTHERE_ACTION", title: "No Longer There", options: [])
        let trailReportCategory = UNNotificationCategory(identifier: "TRAILREPORT_CATEGORY", actions: [confirmAction, noLongerThereAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        notificationCenter.setNotificationCategories([trailReportCategory])
    }
    
    func confirmAction()
    {
        
    }
    func noLongerThereAction(trailReportID: String)
    {
       deleteTrailReport(id: trailReportID)
    }
}
extension LocationManager: UNUserNotificationCenterDelegate {
    // 1
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // 2
        print("Received Notification")
        // 3
        let userInfo = response.notification.request.content.userInfo
        let trailReport = userInfo["TRAIL_REPORT"] as! String
        
        switch response.actionIdentifier {
        case "CONFIRM_ACTION":
            confirmAction()
        case "NOLONGERTHERE_ACTION":
            noLongerThereAction(trailReportID: trailReport)
        default:
            break
        }
        completionHandler()
    }
    
    // 4
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 5
        print("Received Notification in Foreground")
        // 6
        completionHandler(.sound)
    }
}

