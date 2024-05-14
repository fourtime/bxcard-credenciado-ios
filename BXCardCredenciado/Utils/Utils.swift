//
//  Utils.swift
//  BXCard
//
//  Created by Daive Simões on 14/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import InputMask
import SafariServices

class Utils {
    
    static func formatCurrency(value: Double, _ symbol: String? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        if let symbol = symbol {
            formatter.currencySymbol = symbol
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(String(describing: formatter.currencySymbol))0,00"
    }
    
    static func formatDate(date: Date, withOutFormat outFormat: String = Constants.MASKS._DEFAULT_DATE_TIME) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = outFormat
        return formatter.string(from: date)
    }
    
    static func formatDate(string: String, withInFormat inFormat: String = Constants.MASKS._DEFAULT_DATE_TIME, andOutFormat outFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inFormat
        if let date = formatter.date(from: string) {
            formatter.dateFormat = outFormat
            return formatter.string(from: date)
        }
        
        return ""
    }
    
    static func mask(text: String?, withMask mask: String) -> String {
        if let text = text {
            let mask: Mask = try! Mask(format: mask)
            let result: Mask.Result = mask.apply(toText: CaretString(string: text, caretPosition: text.endIndex, caretGravity: .forward(autocomplete: false)))
            return result.formattedText.string
            
        } else {
            return ""
        }
    }
    
    static func getSafariController(withURL url: URL) -> SFSafariViewController? {
        let safariVC = SFSafariViewController(url: url)
        return safariVC
    }
    
    static func getDayName(fromDate date: Date?, withLocaleIdentifier localeId: String = "pt-BR") -> String {
        if let date = date {
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: localeId)
            let dayDate = calendar.component(.weekday, from: date)
            return calendar.weekdaySymbols[dayDate - 1]
        }
        
        return ""
    }
    
    static func getMonthName(fromDate date: Date?, withLocaleIdentifier localeId: String = "pt-BR") -> String {
        if let date = date {
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: localeId)
            let monthDate = calendar.component(.month, from: date)
            return calendar.monthSymbols[monthDate - 1]
        }
        
        return ""
    }
    
    
}
