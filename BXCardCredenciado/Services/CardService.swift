//
//  CardService.swift
//  BXCard
//
//  Created by Daive Simões on 18/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class CardService {
    
    // MARK: - Singleton
    static let instance = CardService()
    
    // MARK: - Private Methods
    private init() { }
    
    // MARK: - Public Methods
    func getAcceptedCards(withCompletion completion: @escaping (Bool) -> ()) {
        
        AF.request(Constants.URLS._CARDS_TYPE_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.HTTP_HEADERS._BEARER).responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let acceptedCardResponse = try JSONDecoder().decode(AcceptedCardResponse.self, from: response.data!)
                            DataService.instance.acceptedCards = acceptedCardResponse.results
                            completion(true)
                            
                        } catch {
                            debugPrint(error)
                            completion(false)
                        }
                        
                    default:
                        debugPrint(String(describing: response.error))
                        completion(false)
                    }
                    
                } else {
                    debugPrint(String(describing: response.error))
                    completion(false)
                }
            
            case .failure(let error):
                debugPrint(String(describing: error))
                completion(false)
            }
        }
        
    }
    
}
