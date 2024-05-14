//
//  Date.swift
//  BXCard
//
//  Created by Daive Simões on 01/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

extension Date {
    
    func monthAsString(_ localeIdentifier: String = "pt-BR") -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: localeIdentifier)
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
}

