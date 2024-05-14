//
//  LoginErrorResponse.swift
//  BXCard
//
//  Created by Daive Simões on 18/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct LoginErrorResponse: Codable {
    
    // MARK: - Public Properties
    let error: String?
    let moreInfo: String?
    let details: [String]?
    let status: Int?
    
}

struct ErrorResponse: Codable {
    
    // MARK: - Public Properties
    let error: String?
    let moreInfo: String?
    let details: [String]?
    let status: Int?
    
}
