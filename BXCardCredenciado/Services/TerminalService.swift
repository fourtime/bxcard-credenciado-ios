//
//  TerminalService.swift
//  BXCard
//
//  Created by Daive Simões on 18/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

class TerminalService {
    
    // MARK: - Singleton
    static let instance = TerminalService()
    
    // MARK: - Private Properties
    private let _APPLICATION_KEY = "7d6bdcdc-3b4d-4692-93ed-812cb849fe35:40*K07188f0d54J14b071##cf1Xh39c97bf$"
    private var renewTimer = Timer()
    
    // MARK: - Private Methods
    private init() { }
    
    // MARK: - Public Methods
    @objc func login(withCompletion completion: ((Bool) -> ())?) {
        let expiration = DataService.instance.accessTokenExpiration ?? Date()
        if expiration > Date() {
            completion?(true)
            return
        }
        
        print("Renewing auth ...")
        let cnpj = DataService.instance.terminal?.cnpj ?? ""
        let terminalCode = DataService.instance.terminalCode
        
        renewTimer.invalidate()
        DataService.instance.clearToken()
        self.initialize(withCNPJ: cnpj, andTerminal: terminalCode, withCompletion: { (loginResponse, error) in
            if error == nil, let loginResponse = loginResponse {
                completion?(true)
                
            } else {
                completion?(false)
            }
        })
    }
    
    deinit {
        renewTimer.invalidate()
    }
    
    func initialize(withCNPJ cnpj: String, andTerminal terminal: String, withCompletion completion: @escaping (LoginResponse?, Error?) -> ()) {
        
        let loginParams: Parameters = [
            "applicationKey" : _APPLICATION_KEY,
            "username" : "\(DataService.instance.deviceID)@\(cnpj.onlyNumbers())",
            "password" : terminal
        ]
        
        AF.request(Constants.URLS._TERMINAL_INITIALIZE_URL, method: .post, parameters: loginParams, encoding: URLEncoding.httpBody, headers: nil).log().responseJSON { (response) in
            debugPrint(response)

            let defaultError = NSError(domain: "Este terminal já se encontra inicializado em outro dispositivo.", code: -1, userInfo: nil)
            
            switch response.result {
            case .success(_):
                if let httpErrorCode = response.response?.statusCode {
                    switch httpErrorCode {
                    case 200..<300:
                        do {
                            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: response.data!)
                            
                            DataService.instance.accessToken = loginResponse.token.accessToken
                            DataService.instance.accessTokenExpiration = Calendar.current.date(byAdding: .second, value: loginResponse.token.expiresIn, to: Date())
                            DataService.instance.terminalCode = terminal
                            
                            self.startRenewAuthenticationTimer(toDate: DataService.instance.accessTokenExpiration)
                            
                            TerminalService.instance.getTerminalData(withCompletion: { (result) in
                                if result {
                                    completion(loginResponse, nil)
                                } else {
                                    completion(nil, nil)
                                }
                            })
                            
                            TerminalService.instance.saveToken(forFirebase: DataService.instance.fcmToken, withCompletion: { (error) in
                                if let error = error {
                                    print("Save FCM token failed: \(error.localizedDescription)")
                                    
                                } else {
                                    print("FCM registered successfully")
                                }
                            })
                            
                        } catch {
                            completion(nil, defaultError)
                        }
                        
                    case 400..<500:
                        if let loginErrorResponse = try? JSONDecoder().decode(LoginErrorResponse.self, from: response.data!), let message = loginErrorResponse.details?.first {
                            completion(nil, NSError(domain: message, code: -1, userInfo: nil))
                        } else {
                            completion(nil, defaultError)
                        }
                        
                        
                    default:
                        completion(nil, defaultError)
                    }
                }
                
            case .failure(_):
                completion(nil, defaultError)
            }
        }
    }
    
    func getTerminalData(withCompletion completion: @escaping (Bool) -> ()) {
        AF.request(Constants.URLS._TERMINAL_DATA_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Constants.HTTP_HEADERS._BEARER).log().responseJSON { (response) in
            debugPrint(response)
            
            switch response.result {
            case .success(_):
                if let httpResponseCode = response.response?.statusCode {
                    switch httpResponseCode {
                    case 200..<300:
                        do {
                            let terminalDataResponse = try JSONDecoder().decode(TerminalDataResponse.self, from: response.data!)
                            DataService.instance.terminal = terminalDataResponse.results
                            completion(true)
                        } catch {
                            debugPrint(error)
                            completion(false)
                        }
                        
                    default:
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
    
    func startRenewAuthenticationTimer(toDate date: Date?) {
        if let date = date {
            let difference = Calendar.current.dateComponents([.second], from: Date(), to: date)
            let secondsForTimer = (difference.second ?? 0) - 60
            if secondsForTimer > 0 {
                renewTimer.invalidate()
                if #available(iOS 10.0, *) {
                    print("Auth renew timer fired up to \(secondsForTimer) seconds from \(Date())")
                    renewTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(exactly: secondsForTimer)!, repeats: true, block: { (timer) in
                        self.login(withCompletion: nil)
                    })
                    
                } else {
                    print("Auth renew timer fired up to \(secondsForTimer) seconds from \(Date())")
                    renewTimer = Timer.scheduledTimer(timeInterval: TimeInterval(exactly: secondsForTimer)!, target: self, selector: #selector(login(withCompletion:)), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    func getOperatorLinks() {
        AF.request(Constants.URLS._TERMINAL_LINKS_URL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).log().responseJSON { (response) in
            do {
                let terminalDataResponse = try JSONDecoder().decode(TerminalLinksResponse.self, from: response.data!)
                DataService.instance.terminalContact = terminalDataResponse.results.contatoOperadora
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func saveToken(forFirebase token: String, withCompletion completion: ((Error?) -> ())?) {
        let params: Parameters = [
            "imei" : DataService.instance.deviceID,
            "IdInstancia" : token,
            "versao" : 1,
            "plataforma" : "ios"
        ]
        AF.request(Constants.URLS._FIREBASE_TOKEN_SAVE_URL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Constants.HTTP_HEADERS._BEARER).log().response { (response) in
            debugPrint(response)
            switch response.result {
            case .success(_):
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    func invalidateRenewTimer() {
        print("Auth renew timer stopped")
        renewTimer.invalidate()
    }
    
}
