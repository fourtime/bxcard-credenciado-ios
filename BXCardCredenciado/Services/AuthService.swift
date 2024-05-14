//
//  AuthService.swift
//  BXCard
//
//  Created by Daive Simões on 18/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class AuthService {
    
    // MARK: - Singleton
    static let instance = AuthService()
    
    // MARK: - Private Methods
    private init() { }
    
    // MARK: - Public Methods
    func login(withPassword password: String) -> Bool {
        return DataService.instance.userLoginPassword == password
    }
    
}

