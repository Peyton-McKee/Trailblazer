//
//  Connectivity.swift
//  Trailblazer Watch App
//
//  Created by Peyton McKee on 11/14/22.
//

import Foundation

import WatchConnectivity

final class Connectivity : NSObject, ObservableObject {
    @Published var routeName: [String] = []
    static let shared = Connectivity()
    
    override private init() {
        super.init()
        #if !os(watchOS)
        guard WCSession.isSupported() else {
            print("session is not supported on watch os")
            return
        }
        #endif
        WCSession.default.delegate = self
        print("activated session")
        WCSession.default.activate()
    }
    public func send(routeName : [String])
    {
        #if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else {
            print("Companion App is not installed")
            return }
        #else
        guard WCSession.default.isWatchAppInstalled else {
            print("Watch app is not installed")
            return }
        #endif
        guard WCSession.default.activationState == .activated else {
            print("Session is not Active")
            return }
        let routeInfo: [String: [String]] = [ConnectivityTypes.route.rawValue : routeName]
        print("Sent User Info")
        WCSession.default.sendMessage(routeInfo, replyHandler: nil)
    }
    
    private func update(from dictionary: [String: Any])
    {
        let key = ConnectivityTypes.route.rawValue
        guard let name = dictionary[key] as? [String] else { return }
        DispatchQueue.main.async {
            self.routeName = name
        }
    }
}

extension Connectivity: WCSessionDelegate
{
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("Received Transfer")
        update(from: userInfo)
    }
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        print("Finished Transfer")
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Received Message")
        update(from: message)
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard let error = error else {
            print("Activation Status: \(activationState)")
            return
        }
        print("Error: \(error.localizedDescription)")
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif
    
    
}
