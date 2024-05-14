//
//  Constants.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Enums
enum Environment {
    case prd
    case hmg
}

class Constants {

    private static let OPERATOR_CODE = "0023"
    
    // MARK: - Private Properties
    private static let _ENVIRONMENT: Environment = .prd
    
    // MARK: - Public Properties
    static func isProductionEnvironment() -> Bool {
        return _ENVIRONMENT == .prd
    }
    
    // MARK: - Color Constants
    class COLORS {
        static let _GRADIENT_ENABLED_COLORS: [UIColor] = [UIColor.enabledDegradeDarkColor, UIColor.enabledDegradeLightColor]
        static let _GRADIENT_DISABLED_COLORS: [UIColor] = [UIColor.disabledDegradeDarkColor, UIColor.disabledDegradeLightColor]
        static let _GRADIENT_ERROR_COLORS: [UIColor] = [UIColor.attentionDegradeDarkColor, UIColor.attentionDegradeLightColor]
    }
    
    // MARK: - Http Requests Headers
    class HTTP_HEADERS {
        static var _BEARER: HTTPHeaders {
            return ["Authorization" : "Bearer \(DataService.instance.accessToken)"]
        }
    }
    
    // MARK: - Images name
    class IMAGES {
        static let _ALERT_GREEN_IMAGE = UIImage(named: "image-alert-green")
        static let _CHECK_GREEN_IMAGE = UIImage(named: "image-check-green")
        static let _CONNECTION_ERROR = UIImage(named: "icon-connection-error")
        static let _CLOSE_GRAY_ICON = UIImage(named: "icon-cancel-gray")
        static let _ERROR_ICON = UIImage(named: "icon-error-red")
    }
    
    // MARK: - Masks
    class MASKS {
        static let _BR_DATE = "dd/MM/yyyy"
        static let _BR_SHORT_TIME = "HH:mm"
        static let _BR_TIME = "HH:mm:ss"
        static let _DEFAULT_DATE_TIME = "yyyy-MM-dd'T'HH:mm:ss"
        static let _LAST_UPDATE = "dd/MM/yyyy' às 'HH:mm"
        static let _US_DATE = "yyyy-MM-dd"
        
        static let _CNPJ = "[00].[000].[000]/[0000]-[00]"
    }
    
    // MARK: - Custom Notifications
    class NOTIFICATIONS {
        static let _REACHABLE_CONNECTION_NOTIFICATION = "ReachableConnectionNotification"
        static let _UNREACHABLE_CONNECTION_NOTIFICATION = "UnreachableConnectionNotification"
    }
    
    // MARK: - URL Constants
    class URLS {
        // MARK: - Private Properties
        private static let _HOST_URL = _ENVIRONMENT == .hmg ? "https://www3.tln.com.br": "https://www1.tln.com.br"
        private static let _SECURITY_URL = "\(_HOST_URL)/security"
        private static let _SERVICES_URL = "\(_HOST_URL)/services"
        private static let _QUERY_URL = "\(_SERVICES_URL)/consulta"
        private static let _TRANSACTION_URL = "\(_SERVICES_URL)/transacao"
        
        // MARK: - Public Properties
        static let _CARDS_TYPE_URL = "\(_QUERY_URL)/credenciado/cartoesaceitos"
        static let _TERMINAL_DATA_URL = "\(_QUERY_URL)/credenciado/dadosterminal"
        static let _TERMINAL_SYNTHETIC_TRANSACTIONS_URL = "\(_QUERY_URL)/credenciado/extratosinteticoterminal"
        static let _TERMINAL_ANALYTIC_TRANSACTIONS_URL = "\(_QUERY_URL)/credenciado/extratoanaliticoterminal"
        static let _TERMINAL_LINKS_URL = "\(_SERVICES_URL)/usuario/mobile/linksuteis/\(OPERATOR_CODE)"
        static let _TERMINAL_INITIALIZE_URL = "\(_SERVICES_URL)/usuario/mobile/inicializaappterminal"
        
        static let _POSTPAID_CARD_CANCEL_URL = "\(_TRANSACTION_URL)/cartao/cancelatransacao"
        static let _PREPAID_CARD_CANCEL_URL = "\(_TRANSACTION_URL)/cartao/cancelatransacao"
        
        static let _CARD_QRCODE_GENERATE_URL = "\(_TRANSACTION_URL)/cartao/geraqrcodepagamento"
        static let _FLEET_QRCODE_GENERATE_URL = "\(_TRANSACTION_URL)/qrcode/novoFrota"
        
        static let _FIREBASE_TOKEN_SAVE_URL = "\(_SERVICES_URL)/usuario/mobile/configurainstanciaapp"
    }
    
}
