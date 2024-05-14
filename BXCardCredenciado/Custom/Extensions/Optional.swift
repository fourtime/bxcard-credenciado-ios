//
//  Optional.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    var stringValue: String {
        return self ?? ""
    }
    
}

extension Optional where Wrapped == Int {
    
    var intValue: Int {
        return self ?? 0
    }
    
}

extension Optional where Wrapped == Double {
    
    var doubleValue: Double {
        return self ?? 0.0
    }
    
}

extension Optional where Wrapped == Bool {
    
    var boolValue: Bool {
        return self ?? false
    }
    
}
