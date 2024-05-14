//
//  ParcelsVC.swift
//  BXCard
//
//  Created by Daive Simões on 14/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ParcelsVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbValue: UILabel!
    @IBOutlet weak var lbMaximumParcels: UILabel!
    @IBOutlet weak var tfParcels: UITextField!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    var value: Double?
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        tfParcels.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        tfParcels.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postPaidQRCodeVCSegue", let qrCodeVC = segue.destination as? CardQRCodeVC {
            qrCodeVC.parcelsNumber = Int(self.tfParcels.text!)!
            qrCodeVC.totalValue = value
        }
    }
    
    // MARK: - Keyboard Notifications
    @objc override func keyboardWillAppear(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: duration, animations: {
            self.bottomConstraint.constant = keyboardFrame.height + 20.0
            self.view.layoutIfNeeded()
        })
    }
    
    @objc override func keyboardWillDisappear(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        view.layoutIfNeeded()
        UIView.animate(withDuration: duration, animations: {
            self.bottomConstraint.constant = 20.0
            self.view.layoutIfNeeded()
        })
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        lbValue.text = Utils.formatCurrency(value: self.value!, "R$ ")
        lbMaximumParcels.text = "Em até \(DataService.instance.terminal?.maximumParcels ?? 1)x"
        
        tfParcels.clear()
        
        btnContinue.disable()
    }
    
    // MARK: - IBActions
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        performSegue(withIdentifier: "postPaidQRCodeVCSegue", sender: nil)
    }
    
    @IBAction func parcelsUnwindAction(_ unwindSegue: UIStoryboardSegue) { }
    
}


// MARK: - UITextFieldDelegate
extension ParcelsVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let swiftRange = Range(range, in: text) {
            let valueStr = text.replacingCharacters(in: swiftRange, with: string)
            if let value = Int(valueStr), value > 0, value <= DataService.instance.terminal!.maximumParcels {
                btnContinue.enable()
            } else {
                btnContinue.disable()
            }
        }
        
        return true
    }
    
}


