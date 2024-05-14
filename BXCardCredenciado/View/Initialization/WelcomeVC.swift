//
//  WelcomeVC.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class WelcomeVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnEnter: Button!
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEnter.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
    }
    
}
