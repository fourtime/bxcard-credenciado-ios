//
//  TerminalDataResponse.swift
//  BXCard
//
//  Created by Daive Simões on 18/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct TerminalDataResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let results: TerminalData
    
}

struct TerminalData: Codable {
    
    // MARK: - Public Properties
    let associatedCode: String
    let cnpj: String
    let corporateName: String
    let address: String
    let neighborhood: String
    let city: String
    let state: String
    let postalCode: String
    let maximumParcels: Int
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case associatedCode = "codigoCredenciado"
        case cnpj
        case corporateName = "razaoSocial"
        case address = "endereco"
        case neighborhood = "bairro"
        case city = "cidade"
        case state = "uf"
        case postalCode = "cep"
        case maximumParcels = "maximoParcelas"
    }
    
}
