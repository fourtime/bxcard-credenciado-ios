//
//  ProductItemCell.swift
//  BXCard
//
//  Created by Daive Simões on 28/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class ProductItemCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbQty: UILabel!
    
    // MARK: - Private Properties
    private var controller: BaseVC?
    private var productItem: ProductItem?
    
    // MARK: - Public Methods
    func configure(withProductItem productItem: ProductItem, forController controller: BaseVC) {
        self.controller = controller
        self.productItem = productItem
        
        lbDescription.text = productItem.product?.fullDescription
        lbValue.text = Utils.formatCurrency(value: productItem.value ?? 0.0, "R$ ")
        lbQty.text = productItem.qtyWithUnit
    }
    
    // MARK: - IBActions
    @IBAction func didTapDeleteProductItemButton(_ sender: UIButton) {
        if let controller = self.controller, let product = self.productItem?.product {
            let message = "Deseja realmente remover \(product.fullDescription)"
            controller.showAlert(forController: controller, title: "Remover produto", message: message, leftButtonTitle: "Fechar", leftButtonType: .bordered, leftButtonBorderColor: UIColor.closeButtonBorderColor, rightButtonTitle: "Remover", rightButtonType: .normal, rightButtonBorderColor: nil, closeButtonImage: Constants.IMAGES._CLOSE_GRAY_ICON, withId: "deleteProductItemAlert", sender: productItem)
        }
    }

}
