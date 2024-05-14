//
//  FleetQRCodeVC.swift
//  BXCard
//
//  Created by Daive Simões on 28/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class FleetQRCodeVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbTotalValue: UILabel!
    @IBOutlet weak var imQRCode: UIImageView!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var aiIndicator: UIActivityIndicatorView!
    @IBOutlet weak var vwReload: UIView!
    
    // MARK: - Private Properties
    private var total = 0.0
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        } else {
            generateQRCode()
        }
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        btnContinue.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        
        total = getTotalValue()
        lbTotalValue.text = Utils.formatCurrency(value: total)
        
        vwReload.isHidden = true
    }
    
    private func getTotalValue() -> Double {
        if let products = BXCardApp.instance.fleetTransaction?.products {
            return products.reduce(0, { $0 + ($1.value ?? 0.0) } )
        }
        
        return 0.0
    }
    
    private func generateQRCode() {
        vwReload.isHidden = true
        aiIndicator.startAnimating()
        QRCodeService.instance.generateFleetQRCode { (qrcodeImage, error) in
            self.aiIndicator.stopAnimating()
            if let error = error {
                debugPrint(error)
                self.showGenericErrorAlert(forController: self)
                self.vwReload.isHidden = false
                
            } else if let qrcodeImage = qrcodeImage {
                self.imQRCode.image = qrcodeImage
            } else {
                self.vwReload.isHidden = false
            }
        }
    }
    
    private func tryToReconect() {
        if !ConnectivityService.instance.isConnected {
            checkConnection()
            
        } else {
            TerminalService.instance.login { (granted) in
                if granted {
                    self.generateQRCode()
                    
                } else {
                    self.checkConnection()
                }
            }
        }
    }
    
    private func reloadQRCode() {
        aiIndicator.startAnimating()
        TerminalService.instance.login { (granted) in
            if granted {
                self.generateQRCode()
                
            } else {
                self.aiIndicator.stopAnimating()
                self.vwReload.isHidden = false
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapReloadView(_ sender: UITapGestureRecognizer) {
        reloadQRCode()
    }
    
}


// MARK: - AlertDelegate
extension FleetQRCodeVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == "tryNewConnectionAlert" {
            tryToReconect()
        }
    }
    
}
