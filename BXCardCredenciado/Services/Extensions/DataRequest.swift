//
//  DataRequest.swift
//  PersonalCardCredenciado
//
//  Created by Rafael Rocha Gans on 04/05/22.
//  Copyright © 2022 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    public func log() -> Self {
        #if DEBUG
            debugPrint("=======================================")
            debugPrint(self)
            debugPrint("=======================================")
        #endif
        return self
    }
}

extension URLRequest {
    public func log() -> Self {
        #if DEBUG
            debugPrint("=======================================")
            debugPrint(self)
            debugPrint("=======================================")
        #endif
        return self
    }
}
