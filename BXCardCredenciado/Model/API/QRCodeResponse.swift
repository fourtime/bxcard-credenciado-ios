//
//  QRCodeResponse.swift
//  BXCard
//
//  Created by Daive Simões on 30/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct QRCodeResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let results: String
    
}
