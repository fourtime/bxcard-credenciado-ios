//
//  CardType.swift
//  BXCard
//
//  Created by Daive Simões on 18/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

enum CardType: Int {
    case postPaid = 0
    case prePaid = 1
    case fleet = 2
    
    var description: String {
        switch rawValue {
        case 0:
            return "Pós-Pago"
        case 1:
            return "Pré-Pago"
        case 2:
            return "Frota"
        default:
            return ""
        }
    }
    
    init?(description: String) {
        switch description.lowercased() {
        case "pos pago": self.init(rawValue: 0)
        case "pre pago": self.init(rawValue: 1)
        case "frota": self.init(rawValue: 2)
        default: return nil
        }
    }
}
