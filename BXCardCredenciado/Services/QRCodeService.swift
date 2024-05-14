//
//  QRCodeService.swift
//  BXCard
//
//  Created by Daive Simões on 30/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class QRCodeService {
    
    // MARK: - Singleton
    static let instance = QRCodeService()
    
    // MARK: - Private Methods
    private init() { }
    
    // MARK: - Public Methods
    func generateCardQRCode(withParcelsNumber parcels: Int, andTotalValue total: Double, withCompletion completion: @escaping (UIImage?, Error?) -> ()) {
        
        let params: Parameters = [
            "dataHoraGeracao" : Utils.formatDate(date: Date(), withOutFormat: Constants.MASKS._DEFAULT_DATE_TIME),
            "numeroParcelas" : parcels,
            "valor" : total
        ]
        
        AF.request(Constants.URLS._CARD_QRCODE_GENERATE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Constants.HTTP_HEADERS._BEARER).log().response { (response) in
            
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode, (200..<300).contains(httpResponseCode) {
                    do {
                        let qrcodeData = try JSONDecoder().decode(QRCodeResponse.self, from: response.data!)
                        completion(qrcodeData.results.decodeToImage(), nil)
                        
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, NSError(domain: "", code: response.response!.statusCode, userInfo: nil))
                }
                
            case .failure(let error):
                debugPrint(String(describing: error))
                completion(nil, error)
            }
        }
        
    }
    
    func generateFleetQRCode(withCompletion completion: @escaping (UIImage?, Error?) -> ()) {
        
        let params: Parameters = [
            "dataHoraTransacao" : Utils.formatDate(date: Date(), withOutFormat: Constants.MASKS._DEFAULT_DATE_TIME),
            "coo" : 000000000000,
            "odometro" : BXCardApp.instance.fleetTransaction?.odometer.intValue as Any,
            "codigoCondutor" : BXCardApp.instance.fleetTransaction?.conductorCode.intValue as Any,
            "servicos" : BXCardApp.instance.fleetTransaction?.servicesJSON as Any
        ]
        
        AF.request(Constants.URLS._FLEET_QRCODE_GENERATE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Constants.HTTP_HEADERS._BEARER).log().responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode, (200..<300).contains(httpResponseCode) {
                    do {
                        let qrcodeData = try JSONDecoder().decode(QRCodeResponse.self, from: response.data!)
                        completion(qrcodeData.results.decodeToImage(), nil)
                        
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, NSError(domain: "", code: response.response!.statusCode, userInfo: nil))
                }
                
            case .failure(let error):
                debugPrint(String(describing: error))
                completion(nil, error)
            }
        }
        
    }
    
}
