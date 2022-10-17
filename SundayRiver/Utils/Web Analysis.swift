//
//  Web Analysis.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/23/22.
//

import Foundation

//
//  ViewController.swift
//  SundayRiver
//
//  Created by Peyton McKee on 3/8/22.
//

import UIKit
import UserNotifications
import WebKit

class WebAnalysis: NSObject, WKNavigationDelegate {
    
    let webView = WKWebView()
    
    var dateComponents = DateComponents()
    var dateComponentsTwo = DateComponents()
    var numLiftsClosed = 0
    var numLiftsOpen = 0
    let liftNames = ["Barker", "South Ridge", "Quantom Leap", "Locke", "Alera Competition Lift", "North Peak", "Chondola", "Spruce", "White Cap Quad", "White Heat Quad", "Little White Cap", "Aurora", "Jordan Double", "Jordan Quad", "Oz"]
    var closedLifts = ""
    
    func configureDateComponents(){
        dateComponents.calendar = Calendar.current
        dateComponents.weekday = 7
        dateComponents.hour = 8
        dateComponents.minute = 30
        dateComponentsTwo.calendar = Calendar.current
        dateComponentsTwo.weekday = 1
        dateComponentsTwo.hour = 8
        dateComponentsTwo.minute = 30
    }
    func askPermission()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {
            success, error in
            if success{
                print("yay")
            }
            else if let error = error{
                print(error.localizedDescription)
            }
        })
    }
    func configureNotification(title : String, subtitle : String) -> UNNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = UNNotificationSound.default
        content.body = subtitle
        return content
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("test")
        getWebsiteData(webView: webView, completion: {
            value in
            switch value{
            case .success(let value):
                print("test")
                print(value)
               let liftStatuses = value
                
                for i in 0 ..< liftStatuses.count{
                    if liftStatuses[i] == "Closed"
                    {
                        self.numLiftsClosed += 1
                        self.closedLifts += "\(self.liftNames[i]), "
                    }
                    else if liftStatuses[i] == "Open"
                    {
                        self.numLiftsOpen += 1
                    }
                }
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: self.dateComponents, repeats: true)
                let trigger2 = UNCalendarNotificationTrigger(dateMatching: self.dateComponentsTwo, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: self.configureNotification(title: "\(String(self.numLiftsClosed)) closed lifts: , \(String(self.numLiftsOpen))", subtitle: "\(self.closedLifts)"), trigger: trigger)
                let request2 = UNNotificationRequest(identifier: UUID().uuidString, content: self.configureNotification(title: "\(String(self.numLiftsClosed)) closed lifts: , \(String(self.numLiftsOpen))", subtitle: "\(self.closedLifts)"), trigger: trigger2)
                UNUserNotificationCenter.current().add(request)
                UNUserNotificationCenter.current().add(request2)
                print("Notifications Stored")
            case .failure(let error):
                    print("failed to find data - \(error)")
                
            }
        })
    }
}

