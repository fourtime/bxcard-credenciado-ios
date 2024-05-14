//
//  ServiceCodeCell.swift
//  BXCard
//
//  Created by Daive Simões on 25/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class ServiceCodeCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var lbService: UILabel!
    
    // MARK: - Public Properties
    func configure(withProduct product: Product) {
        lbService.text = product.fullDescription
    }

}
