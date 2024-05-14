//
//  TransactionCell.swift
//  BXCard
//
//  Created by Daive Simões on 15/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lbLongDate: UILabel!
    @IBOutlet weak var lbDayName: UILabel!
    @IBOutlet weak var lbValue: UILabel!

    // MARK: - Public Methods
    func configure(withTransactionSummary summary: TransactionSummary) {
        lbLongDate.text = summary.dayAndShortMonth
        lbDayName.text = Utils.getDayName(fromDate: summary.date.toDate(withInFormat: Constants.MASKS._US_DATE))
        lbValue.text = Utils.formatCurrency(value: summary.value, "R$ ")
    }
    
}
