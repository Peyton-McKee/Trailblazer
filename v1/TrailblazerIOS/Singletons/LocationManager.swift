//
//  LocationManager.swift
//  Trailblazer
//
//  Created by Peyton McKee on 3/11/23.
//

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: CLLocationManager, ObservableObject {
    static let shared = LocationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    var trailReportRegion : CLCircularRegion?

    func makeTrailReportRegion(trailReport: TrailReport) {
        let region = CLCircularRegion(
            center: CLLocationCoordinate2D(latitude: trailReport.latitude, longitude: trailReport.longitude),
            radius: 75,
            identifier: UUID().uuidString)
        region.notifyOnEntry = true
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
    
    func registerNotification(title: String, body: String, trailReportID: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        notificationContent.sound = .default
        notificationContent.userInfo = ["TRAIL_REPORT": trailReportID]
        notificationContent.categoryIdentifier = body
        
        let trigger = UNLocationNotificationTrigger(region: trailReportRegion!, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger)
        
        notificationCenter
            .add(request) { error in
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
            }
        
    }
    
    override init() {
        super.init()
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
        APIHandler.shared.deleteTrailReport(id: trailReportID)
    }
}
extension LocationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("Received Notification")
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
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("Received Notification in Foreground")
        completionHandler(.sound)
    }
}
