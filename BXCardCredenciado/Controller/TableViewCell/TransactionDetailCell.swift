//
//  TransactionDetailCell.swift
//  BXCard
//
//  Created by Daive Simões on 15/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class TransactionDetailCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lbTransactionID: UILabel!
    @IBOutlet weak var lbCardNumber: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - Private Properties
    private var controller: BaseVC?
    private var transaction: AnalyticTransaction?
    
    // MARK: - Public Methods
    func configure(forController controller: BaseVC, withTransaction transaction: AnalyticTransaction) {
        self.controller = controller
        self.transaction = transaction
        
        cancelButton.isHidden = (transaction.cardId.count <= 0)
        
        lbTransactionID.text = "\(transaction.nsuAuthorization)"
        lbCardNumber.text = transaction.formattedCardNumber
        lbValue.text = Utils.formatCurrency(value: transaction.value, "R$ ")
        lbTime.text = Utils.formatDate(string: transaction.transactionDate, andOutFormat: Constants.MASKS._BR_SHORT_TIME)
    }
    
    // MARK: - Private Methods
    private func confirmCancelFor(transaction: AnalyticTransaction?) {
        if let transaction = transaction, let controller = controller {
            controller.showAlert(forController: controller, title: "Confirme o cancelamento", message: transaction.description, leftButtonTitle: "Fechar", leftButtonType: .normal, leftButtonBorderColor: nil, rightButtonTitle: "Cancelar", rightButtonType: .destructive, rightButtonBorderColor: nil, closeButtonImage: Constants.IMAGES._CLOSE_GRAY_ICON, withId: "deleteConfirmedAlert", sender: transaction)
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapCancelTransactionButton(_ sender: UIButton) {
        confirmCancelFor(transaction: self.transaction)
    }

}
