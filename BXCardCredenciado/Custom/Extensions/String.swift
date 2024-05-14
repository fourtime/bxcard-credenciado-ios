//
//  String.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

extension String {
 
    var camelized: String {
        guard !isEmpty else {
            return ""
        }
        
        let parts = components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})
        
        return ([first] + rest).joined(separator: "")
    }
    
    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }

    func onlyNumbers() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    func toDate(withInFormat inFormat: String = Constants.MASKS._DEFAULT_DATE_TIME) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = inFormat
        return formatter.date(from: self)
    }
    
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    func decodeToImage() -> UIImage? {
        if let decData = Data(base64Encoded: self, options: .ignoreUnknownCharacters), decData.count > 0, let image = UIImage(data: decData) {
            return image
        }
        
        return nil
    }

}


extension StringProtocol {
    
    func paddingToLeft(upTo length: Int, using element: Element) -> String {
        return String(repeatElement(element, count: Swift.max(0, length - count))) + suffix(Swift.max(count, count - length))
    }
    
    
    
}
