//
//  AcceptedCardResponse.swift
//  BXCard
//
//  Created by Daive Simões on 18/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct AcceptedCardResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let results: [Int]
    
}
