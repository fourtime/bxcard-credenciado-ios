//
//  TransactionResponse.swift
//  BXCard
//
//  Created by Daive Simões on 24/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

struct AnalyticTransactionResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let results: AnalyticTransactionResult
    
}

struct AnalyticTransactionResult: Codable {
    let numeroPagina: Int
    let tamanhoPagina: Int
    let totalRegistros: Int
    let valorTotalPeriodo: Float
    let valorTicketMedio: Float
    let dados: [AnalyticTransaction]
}

struct AnalyticTransaction: Codable {
    
    // MARK: - Public Properties
    let cardId: String
    let transactionDate: String
    let lastCardDigits: String
    let value: Double
    let parcelsNumber: Int
    let cardType: Int
    let nsuAuthorization: String
    let nsuHost: String
    
    // MARK: - Mapping Keys
    enum CodingKeys: String, CodingKey {
        case cardId = "idCartao"
        case transactionDate = "dataHoraTransacao"
        case lastCardDigits = "ultimosDigitosCartao"
        case value = "valor"
        case parcelsNumber = "numeroParcelas"
        case cardType = "tipoCartao"
        case nsuAuthorization = "nsuAutorizacao"
        case nsuHost
    }
    
    var description: String {
        return "Valor: \(Utils.formatCurrency(value: self.value, "R$ "))\n\(self.formattedCardNumber)"
    }
    
    var formattedCardNumber: String {
        return "Cartão final: \(self.lastCardDigits)"
    }
    
    var onlyDate: String {
        return self.transactionDate.count > 10 ? self.transactionDate.prefix(10).trimmingCharacters(in: .whitespaces) : ""
    }
    
    var dayAndDescriptiveMonth: String {
        if let date = self.onlyDate.toDate(withInFormat: Constants.MASKS._US_DATE) {
            return "\(Calendar.current.component(.day, from: date)) de \(Utils.getMonthName(fromDate: date).uppercasingFirst)"
        }
        
        return self.onlyDate
    }
}


struct SyntheticTransactionResponse: Codable {
    
    // MARK: - Public Properties
    let status: Int
    let results: SyntheticTransactionResult
    
}

struct SyntheticTransactionResult: Codable {
    let numeroPagina: Int
    let tamanhoPagina: Int
    let totalRegistros: Int
    let valorTotalPeriodo: Float
    let valorTicketMedio: Float
    let dados: [SyntheticTransaction]
}

struct SyntheticTransaction: Codable {
    let data: String
    let valor: Double
    let totalTransacoes: Int
    
    var onlyDate: String {
        return self.data.count > 10 ? self.data.prefix(10).trimmingCharacters(in: .whitespaces) : ""
    }
    
    var dayAndDescriptiveMonth: String {
        if let date = self.onlyDate.toDate(withInFormat: Constants.MASKS._US_DATE) {
            return "\(Calendar.current.component(.day, from: date)) de \(Utils.getMonthName(fromDate: date).uppercasingFirst)"
        }
        
        return self.onlyDate
    }
}
