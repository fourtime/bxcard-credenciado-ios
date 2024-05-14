//
//  TransactionSummary.swift
//  BXCard
//
//  Created by Daive Simões on 24/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct TransactionSummary {
    
    // MARK: - Public Properties
    let date: String
    let value: Double
    
}


// MARK: - extensions
extension TransactionSummary {
    
    var dayAndShortMonth: String {
        let dateStr = Utils.formatDate(string: self.date, withInFormat: Constants.MASKS._US_DATE, andOutFormat: Constants.MASKS._BR_DATE)
        if let date = dateStr.toDate(withInFormat: Constants.MASKS._BR_DATE) {
            let day = String(describing: Calendar.current.component(.day, from: date)).paddingToLeft(upTo: 2, using: "0")
            return "\(day) \(date.monthAsString().uppercased().prefix(3))"
        }
        return ""
    }
    
}
