//
//  DataService.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

class DataService {
    
    // MARK: - Singleton
    static let instance = DataService()
    
    // MARK: - DB Keys
    private let AccessTokenKey = "_AccessTokenKey_"
    private let AccessTokenExpirationKey = "_AccessTokenExpirationKey_"
    private let AcceptedCardsKey = "_AcceptedCardsKey_"
    private let DeviceIDKey = "_DeviceIDKey_"
    private let FirstAccessKey = "_FirstAccessKey_"
    private let LoggedInKey = "_LoggedInKey_"
    private let TerminalKey = "_TerminalKey_"
    private let TerminalCodeKey = "_TerminalCodeKey_"
    private let TerminalContactKey = "_TerminalContactKey_"
    private let UserLoginPasswordKey = "_UserLoginPasswordKey_"
    private let FCMTokenKey = "_FCMTokenKey_"
    
    // MARK: - Private properties
    private var _isDataLoaded = false
    private var _userData: [String : Any] = [:]
    private let _database = UserDefaults.standard
    private var _datasourceKey: String {
        return "br.com.BXCard.credenciado.local.database"
    }
    
    // MARK: - Public properties
    var autoSynchronize = true
    
    var accessToken: String {
        get {
            return getValueOrDefault(name: AccessTokenKey, defaultValue: "")
        }
        
        set {
            setValue(name: AccessTokenKey, value: newValue)
        }
    }
    
    var accessTokenExpiration: Date? {
        get {
            return getValueOrDefault(name: AccessTokenExpirationKey, defaultValue: nil)
        }
        
        set {
            if let newValue = newValue {
                setValue(name: AccessTokenExpirationKey, value: newValue)
            } else {
                removeValue(name: AccessTokenExpirationKey)
            }
        }
    }
    
    var acceptedCards: [Int] {
        get {
            if let decodedAcceptedCards = try? JSONDecoder().decode([Int].self, from: getValueOrDefault(name: AcceptedCardsKey, defaultValue: Data())) {
                return decodedAcceptedCards
            }
            
            return [Int]()
        }
        
        set {
            if let acceptedCards = try? JSONEncoder().encode(newValue) {
                setValue(name: AcceptedCardsKey, value: acceptedCards)
            } else {
                removeValue(name: AcceptedCardsKey)
            }
        }
    }
    
    var deviceID: String {
        if !Constants.isProductionEnvironment() {
            return "A70A678A-E4EB-4CAA-8BB3-9DD030E246A9"
        }
        
        return getValueOrDefault(name: DeviceIDKey, defaultValue: "")
    }
    
    var isFirstAccess: Bool {
        get {
            return getValueOrDefault(name: FirstAccessKey, defaultValue: true)
        }
        
        set {
            setValue(name: FirstAccessKey, value: newValue)
        }
    }
    
    var isLoggedIn: Bool {
        get {
            return getValueOrDefault(name: LoggedInKey, defaultValue: false)
        }
        
        set {
            setValue(name: LoggedInKey, value: newValue)
        }
    }
    
    var terminal: TerminalData? {
        get {
            if let decodedTerminalData = try? JSONDecoder().decode(TerminalData.self, from: getValueOrDefault(name: TerminalKey, defaultValue: Data())) {
                return decodedTerminalData
            }
            
            return nil
        }
        
        set {
            if let newValue = newValue, let terminalData = try? JSONEncoder().encode(newValue) {
                setValue(name: TerminalKey, value: terminalData)
            } else {
                removeValue(name: TerminalKey)
            }
        }
    }
    
    var terminalCode: String {
        get {
            return getValueOrDefault(name: TerminalCodeKey, defaultValue: "")
        }
        
        set {
            setValue(name: TerminalCodeKey, value: newValue)
        }
    }
    
    var terminalContact: URL? {
        get {
            let rawUrl = getValueOrDefault(name: TerminalContactKey, defaultValue: "")
            return URL(string: rawUrl)
        }
        
        set {
            setValue(name: TerminalContactKey, value: newValue?.absoluteString ?? "")
        }
    }
    
    var userLoginPassword: String {
        get {
            return getValueOrDefault(name: UserLoginPasswordKey, defaultValue: "")
        }
        
        set {
            setValue(name: UserLoginPasswordKey, value: newValue)
        }
        
    }
    
    var fcmToken: String {
        get {
            return getValueOrDefault(name: FCMTokenKey, defaultValue: "")
        }
        
        set {
            setValue(name: FCMTokenKey, value: newValue)
        }
        
    }
    
    // MARK: - Private methods
    private init() {
        loadFromSource()
        
        if deviceID.isEmpty {
            setValue(name: DeviceIDKey, value: NSUUID().uuidString)
        }
    }
    
    private func loadFromSource() {
        if let data = _database.dictionary(forKey: _datasourceKey) {
            _userData = data
        } else {
            _userData = [:]
        }
        
        _isDataLoaded = true
    }
    
    private func getValueOrDefault<T: Any>(name: String, defaultValue: T) -> T {
        if !_isDataLoaded {
            loadFromSource()
        }
        
        if let value = _userData[name] as? T {
            return value
        }
        
        return defaultValue
    }
    
    private func getValueOrDefault<T: Any>(name: String) -> T? {
        if !_isDataLoaded {
            loadFromSource()
        }
        
        if let value = _userData[name] as? T {
            return value
        }
        
        return nil
    }
    
    private func setValue<T: Any>(name: String, value: T) {
        if !_isDataLoaded {
            loadFromSource()
        }
        
        self._userData[name] = value
        
        if autoSynchronize {
            synchronize()
        }
    }
    
    private func removeValue(name: String) {
        if !_isDataLoaded {
            loadFromSource()
        }
        
        _userData[name] = ""
        
        if autoSynchronize {
            synchronize()
        }
    }
    
    // MARK: - Public methods
    func clearToken() {
        accessToken = ""
        accessTokenExpiration = nil
    }
    
    func synchronize() {
        if !_isDataLoaded  {
            loadFromSource()
            return
        }
        
        _database.set(_userData, forKey: _datasourceKey)
        _database.synchronize()
    }
    
}

