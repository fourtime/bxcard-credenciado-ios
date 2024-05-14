//
//  Service.swift
//  BXCard
//
//  Created by Daive Simões on 28/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - ItemType Enum
enum ProductType: Int {
    
    case combustivel = 1
    case lubrificante = 2
    case produtos = 4
    case borracharia = 5
    case lavagem = 6
    case manutencao = 7
    case troco = 8
    case outros = 9
    
    static func typeFrom(value: Int) -> ProductType {
        switch value/100 {
        case 1: return ProductType.combustivel
        case 2: return ProductType.lubrificante
        case 4: return ProductType.produtos
        case 5: return ProductType.borracharia
        case 6: return ProductType.lavagem
        case 7: return ProductType.manutencao
        case 8: return ProductType.troco
        default: return ProductType.outros
        }
    }
    
    var titleDescription: String {
        switch self {
        case .combustivel:
            return "Volume em litros"
        default:
            return "Quantidade"
        }
    }
    
    var unity: String {
        switch self {
        case .combustivel:
            return "L"
        default:
            return "un"
        }
    }
    
}

struct Product {
    
    // MARK: - Public Properties
    let id: Int
    let description: String
    let shortDescription: String
    
}


// extensions
extension Product {
    
    var productType: ProductType {
        return ProductType.typeFrom(value: self.id)
    }

    var fullDescription: String {
        return "\(self.id) - \(self.description)"
    }
    
    var unit: String {
        return self.productType.unity
    }
    
}
