//
//  ConnectivityService.swift
//  BXCard
//
//  Created by Daive Simões on 06/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class ConnectivityService {
    
    // MARK: - Singleton
    static let instance = ConnectivityService()
    
    // MARK: - Public Properties
    var isConnected: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    // MARK: - Private Properties
    private let reachbilityManager = NetworkReachabilityManager()
    
    // MARK: - Private Methods
    private init() { }
    
    // MARK: - Public Methods
    func startConnectionListener() {
        reachbilityManager?.startListening(onUpdatePerforming: { status in
            if let isNetworkReachable = self.reachbilityManager?.isReachable, isNetworkReachable {
                NotificationCenter.default.post(name: NSNotification.Name(Constants.NOTIFICATIONS._REACHABLE_CONNECTION_NOTIFICATION), object: nil)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(Constants.NOTIFICATIONS._UNREACHABLE_CONNECTION_NOTIFICATION), object: nil)
            }
        })
    }
    
    func stopConnectionListener() {
        reachbilityManager?.stopListening()
    }
    
}
