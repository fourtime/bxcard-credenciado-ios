//
//  CardQRCodeVC.swift
//  BXCard
//
//  Created by Daive Simões on 14/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class CardQRCodeVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbTotalValue: UILabel!
    @IBOutlet weak var lbParcelsNumber: UILabel!
    @IBOutlet weak var imQRCode: UIImageView!
    @IBOutlet weak var btnFinish: Button!
    @IBOutlet weak var aiIndicator: UIActivityIndicatorView!
    @IBOutlet weak var vwReload: UIView!
    
    // MARK: - Public Properties
    var parcelsNumber: Int?
    var totalValue: Double?
    
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
        btnFinish.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        
        lbTotalValue.text = Utils.formatCurrency(value: self.totalValue ?? 0.0, "R$ ")
        lbParcelsNumber.text = "em \(parcelsNumber ?? 1)x"
        
        vwReload.isHidden = true
    }
    
    private func generateQRCode() {
        vwReload.isHidden = true
        aiIndicator.startAnimating()
        QRCodeService.instance.generateCardQRCode(withParcelsNumber: parcelsNumber!, andTotalValue: totalValue!) { (qrcodeImage, error) in
            self.aiIndicator.stopAnimating()
            if let error = error {
                debugPrint(error)
                self.vwReload.isHidden = false
                self.showGenericErrorAlert(forController: self)
                
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
    @IBAction func didTapBackButton(_ sender: UIButton) {
        if parcelsNumber.intValue == 1 {
            performSegue(withIdentifier: "cardUnwindSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "parcelsUnwindSegue", sender: nil)
        }
        
    }
    
    @IBAction func didTapReloadView(_ sender: UITapGestureRecognizer) {
        reloadQRCode()
    }
    
}


// MARK: - AlertDelegate
extension CardQRCodeVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == "tryNewConnectionAlert" {
            tryToReconect()
        }
    }
    
}
