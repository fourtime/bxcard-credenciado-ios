//
//  ProductService.swift
//  BXCard
//
//  Created by Daive Simões on 28/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

class ProductService {
    
    // MARK: - Singleton
    static let instance = ProductService()
    
    // MARK: - Public Properties
    var products = [Product]()
    
    // MARK: - Private Methods
    private init() {
        products.removeAll()
        products.append(Product(id: 100, description: "GASOLINA COMUM", shortDescription: "GAS COM"))
        products.append(Product(id: 101, description: "GASOLINA ADITIVADA", shortDescription: "GAS ADT"))
        products.append(Product(id: 102, description: "GASOLINA ESPECIAL", shortDescription: "GAS ESP"))
        products.append(Product(id: 103, description: "ALCOOL", shortDescription: "ALC"))
        products.append(Product(id: 104, description: "ALCOOL ADITIVADO", shortDescription: "ALC ADT"))
        products.append(Product(id: 105, description: "DIESEL", shortDescription: "DIESEL"))
        products.append(Product(id: 106, description: "DIESEL ADITIVADO", shortDescription: "DIE ADT"))
        products.append(Product(id: 107, description: "GNV", shortDescription: "GNV"))
        products.append(Product(id: 108, description: "BIODIESEL", shortDescription: "BIODISE"))
        products.append(Product(id: 201, description: "ÓLEO MINERAL", shortDescription: "ÓLEO MI"))
        products.append(Product(id: 202, description: "ÓLEO SINTÉTICO", shortDescription: "ÓLEO SI"))
        products.append(Product(id: 203, description: "ÓLEO SEM-SINTÉTICO", shortDescription: "ÓLEO SE"))
        products.append(Product(id: 204, description: "ÓLEO DA CAIXA", shortDescription: "ÓLEO CX"))
        products.append(Product(id: 400, description: "FILTRO DE ÓLEO", shortDescription: "FIL ÓLE"))
        products.append(Product(id: 401, description: "FILTRO DE COMBUSTÍVEL", shortDescription: "FIL CMB"))
        products.append(Product(id: 402, description: "FILTRO DE AR", shortDescription: "FIL AR"))
        products.append(Product(id: 403, description: "FILTRO DO AR CONDICIONADO", shortDescription: "F AR CO"))
        products.append(Product(id: 404, description: "ADITIVO RADIADOR", shortDescription: "ADT RAD"))
        products.append(Product(id: 405, description: "ADITIVO COMBUSTÍVEL", shortDescription: "ADT CMB"))
        products.append(Product(id: 406, description: "ADITIVO PARABRISA", shortDescription: "ADT PAR"))
        products.append(Product(id: 407, description: "FLUIDO DE FREIO", shortDescription: "FLU FRE"))
        products.append(Product(id: 408, description: "EXTINTOR", shortDescription: "EXTINT"))
        products.append(Product(id: 409, description: "PALHETA", shortDescription: "PALHET"))
        products.append(Product(id: 500, description: "CONSERTO DE PNEU", shortDescription: "CON PNE"))
        products.append(Product(id: 600, description: "LAVAGEM", shortDescription: "LAVAG"))
        products.append(Product(id: 700, description: "MANUTENÇÃO", shortDescription: "MANUT"))
        products.append(Product(id: 800, description: "TROCO", shortDescription: "TROCO"))
    }
    
    // MARK: - Public Methods
    func getProductBy(id: Int) -> Product {
        if let product = products.first(where: { $0.id == id }) {
            return product
        } else {
            return Product(id: id, description: "OUTROS", shortDescription: "OUTROS")
        }
    }
    
}
