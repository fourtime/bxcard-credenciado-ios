//
//  ProductItem.swift
//  BXCard
//
//  Created by Daive Simões on 28/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

class ProductItem {
    
    // MARK: - Public Properties
    var product: Product?
    var quantity: Double?
    var value: Double?
    
}


// MARK: - Extensions
extension ProductItem {
    
    var qtyWithUnit: String {
        if let product = self.product, let qty = self.quantity {
            return "\(Utils.formatCurrency(value: qty)) \(product.unit)"
        }
        return ""
    }
    
    var toJson: [String : Any] {
        let json : [String : Any] = [
            "codigo" : product?.id ?? 999,
            "quantidade" : quantity ?? 0.0,
            "valor" : value ?? 0.00
            ]
        return json
    }
    
}
