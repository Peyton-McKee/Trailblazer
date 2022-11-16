//
//  Connectivity.swift
//  Trailblazer Watch App
//
//  Created by Peyton McKee on 11/14/22.
//

import Foundation

import WatchConnectivity

final class Connectivity : NSObject, ObservableObject {
    @Published var routeIds: [Int] = []
    static let shared = Connectivity()
    
    override private init() {
        super.init()
        #if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
        #endif
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    public func send(routeIds : [Int])
    {
        print("test connectivity \(routeIds)")
        #if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else { return }
        #else
        guard WCSession.default.isWatchAppInstalled else { return }
        #endif
        guard WCSession.default.activationState == .activated else { return }
        let routeInfo: [String: [Int]] = [ConnectivityTypes.route.rawValue : routeIds]
        
        WCSession.default.transferUserInfo(routeInfo)
    }
    
    private func update(from dictionary: [String: Any])
    {
        let key = ConnectivityTypes.route.rawValue
        guard let ids = dictionary[key] as? [Int] else { return }
        self.routeIds = ids
    }
}

extension Connectivity: WCSessionDelegate
{
    func session(_ sessoin: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:])
    {
        print("test watch: \(userInfo)")
        update(from: userInfo)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    #endif
    
    
}
