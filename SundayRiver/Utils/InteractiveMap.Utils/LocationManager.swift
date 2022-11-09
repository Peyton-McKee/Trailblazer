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
    func makeTrailReportRegion(trailReport: ImageAnnotation) {
    // 2
    let region = CLCircularRegion(
      center: trailReport.coordinate,
      radius: 75,
      identifier: UUID().uuidString)
    // 3
    region.notifyOnEntry = true
    // 4
    trailReportRegion = region
  }

  // 1
  func validateLocationAuthorizationStatus() {
    // 2
    switch locationManager.authorizationStatus {
    // 3
    case .notDetermined, .denied, .restricted:
      // 4
      print("Location Services Not Authorized")
      locationManager.requestWhenInUseAuthorization()
      requestNotificationAuthorization()

    // 5
    case .authorizedWhenInUse, .authorizedAlways:
      // 6
      print("Location Services Authorized")
      requestNotificationAuthorization()

    default:
      break
    }
  }

  // 1
  private func requestNotificationAuthorization() {
    // 2
    let options: UNAuthorizationOptions = [.sound, .alert]
    // 3
    notificationCenter
      .requestAuthorization(options: options) { [weak self] result, _ in
        // 4
        print("Auth Request result: \(result)")
        if result {
          self?.registerNotification()
        }
      }
  }

  // 1
  func registerNotification() {
    // 2
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = "Welcome to Swifty TakeOut"
    notificationContent.body = "Your order will be ready shortly."
    notificationContent.sound = .default

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

