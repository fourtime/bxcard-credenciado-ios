//
//  BXCardApp.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

class BXCardApp {
    
    // MARK: - Singleton
    static let instance = BXCardApp()
    
    // MARK: - Public Properties
    var loadingVC: LoadingVC?
    var fleetProduct: ProductItem?
    var fleetProductList = [ProductItem]()
    var fleetTransaction: FleetTransaction?
    
    // MARK: - Gradients
    let defaultGradient: CAGradientLayer = CAGradientLayer()
    let disabledGradient: CAGradientLayer = CAGradientLayer()
    let attentionGradient:  CAGradientLayer = CAGradientLayer()
    
    // MARK: - Private Methods
    private init() { }
    
}
