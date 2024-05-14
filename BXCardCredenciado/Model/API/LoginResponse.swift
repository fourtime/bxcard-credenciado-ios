//
//  LoginResponse.swift
//  BXCard
//
//  Created by Daive Simões on 18/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let token: TokenResponse
    
    enum CodingKeys: String, CodingKey {
        case token = "results"
    }
}

struct TokenResponse: Codable {
    // MARK: - Public Properties
    let scope: String
    let tokenType: String
    let accessToken: String
    let expiresIn: Int
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case scope = "scope"
        case tokenType = "token_Type"
        case accessToken = "access_Token"
        case expiresIn = "expires_In"
    }
}
