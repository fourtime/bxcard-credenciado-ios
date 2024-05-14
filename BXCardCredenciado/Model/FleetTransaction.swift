//
//  FleetTransaction.swift
//  BXCard
//
//  Created by Daive Simões on 29/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

class FleetTransaction {
    
    // MARK: - Public Properties
    var products: [ProductItem]?
    var odometer: Int?
    var conductorCode: Int?
    
}


// MARK: - Extensions
extension FleetTransaction {
    
    var servicesJSON: [[String : Any]] {
        var services = [[String : Any]]()
        if let products = products {
            for product in products {
                services.append(product.toJson)
            }
        }
        return services
    }
    
}
