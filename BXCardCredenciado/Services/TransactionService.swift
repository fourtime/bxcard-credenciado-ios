//
//  TransactionService.swift
//  BXCard
//
//  Created by Daive Simões on 24/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class TransactionService {
    
    // MARK: - Singleton
    static let instance = TransactionService()
    
    // MARK: - Private Methods
    private init() { }
    
    func cancel(transaction: AnalyticTransaction, withCompletion completion: @escaping (Error?) -> ()) {
        let cancelParams: Parameters = [
            "idCartao" : transaction.cardId,
            "nsuHostAutorizacao" : transaction.nsuHost,
            "nsuAutorizacao": transaction.nsuAuthorization,
            "valor" : transaction.value,
            "dataHoraTransacao" : Utils.formatDate(date: Date()),
            "codigoTerminal" : DataService.instance.terminalCode,
            "codigoCredenciado" : Int(DataService.instance.terminal!.associatedCode) ?? 0,
            "dataTransacaoCancelar" : transaction.transactionDate
        ]
        
        let url = CardType(rawValue: transaction.cardType) == .postPaid ? Constants.URLS._POSTPAID_CARD_CANCEL_URL : Constants.URLS._PREPAID_CARD_CANCEL_URL
        
        AF.request(url, method: .post, parameters: cancelParams, encoding: JSONEncoding.default, headers: Constants.HTTP_HEADERS._BEARER).log().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success(_):
                if let httpStatus = response.response?.statusCode, (200..<300).contains(httpStatus) {
                    completion(nil)
                } else {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data!)
                        completion(NSError(domain: errorResponse.details?.first ?? "", code: response.response!.statusCode, userInfo: nil))
                    } catch {
                        completion(NSError(domain: "", code: response.response!.statusCode, userInfo: nil))
                    }
                }
                
            case .failure(let error):
                debugPrint(String(describing: error))
                completion(error)
            }
        }
        
    }
    
    func getSyntheticTransactions(withBeginDate beginDate: Date, andEndDate endDate: Date, _ numeroPagina: Int = 1, _ tamanhoPagina: Int = 100, withCompletion completion: @escaping ([SyntheticTransaction]?, Error?) -> ()) {
        
        let queryParams: Parameters = [
            "dataInicio" : Utils.formatDate(date: beginDate),
            "dataFim" : Utils.formatDate(date: endDate),
            "numeroPagina" : numeroPagina,
            "tamanhoPagina" : tamanhoPagina
        ]
        
        AF.request(Constants.URLS._TERMINAL_SYNTHETIC_TRANSACTIONS_URL, method: .post, parameters: queryParams, encoding: JSONEncoding.default, headers: Constants.HTTP_HEADERS._BEARER).log().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success(_):
                if let httpStatus = response.response?.statusCode {
                    switch httpStatus {
                    case 200..<300:
                        do {
                            let transactionResponse = try JSONDecoder().decode(SyntheticTransactionResponse.self, from: response.data!)
                            completion(transactionResponse.results.dados, nil)
                            
                        } catch {
                            debugPrint(error)
                            completion(nil, error)
                        }
                        
                    default:
                        debugPrint(String(describing: response.error))
                        completion(nil, response.error)
                    }
                }
            case .failure(let error):
                debugPrint(String(describing: error))
                completion(nil, error)
            }
        }
    }
    
    func getAnalyticTransactions(withBeginDate beginDate: Date, andEndDate endDate: Date, _ numeroPagina: Int = 1, _ tamanhoPagina: Int = 100, withCompletion completion: @escaping ([AnalyticTransaction]?, Error?) -> ()) {
        
        let queryParams: Parameters = [
            "dataInicio" : Utils.formatDate(date: beginDate),
            "dataFim" : Utils.formatDate(date: endDate),
            "numeroPagina" : numeroPagina,
            "tamanhoPagina" : tamanhoPagina
        ]
        
        AF.request(Constants.URLS._TERMINAL_ANALYTIC_TRANSACTIONS_URL, method: .post, parameters: queryParams, encoding: JSONEncoding.default, headers: Constants.HTTP_HEADERS._BEARER).log().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success(_):
                if let httpStatus = response.response?.statusCode {
                    switch httpStatus {
                    case 200..<300:
                        do {
                            let transactionResponse = try JSONDecoder().decode(AnalyticTransactionResponse.self, from: response.data!)
                            completion(transactionResponse.results.dados, nil)
                            
                        } catch {
                            debugPrint(error)
                            completion(nil, error)
                        }
                        
                    default:
                        debugPrint(String(describing: response.error))
                        completion(nil, response.error)
                    }
                }
            case .failure(let error):
                debugPrint(String(describing: error))
                completion(nil, error)
            }
        }
    }
    
}
