//
//  QuantityVC.swift
//  BXCard
//
//  Created by Daive Simões on 28/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class QuantityVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var lbSelectedProduct: UILabel!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        tfValue.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        tfValue.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "valueVCSegue", let _ = segue.destination as? ValueVC {
            BXCardApp.instance.fleetProduct?.quantity = Double(tfValue.text!.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "."))
        }
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        super.configureScreen()
        
        tfValue.text = "0,00"
        
        lbSelectedProduct.text = BXCardApp.instance.fleetProduct?.product?.fullDescription
        lbTitle.text = BXCardApp.instance.fleetProduct?.product?.productType.titleDescription
        
        btnContinue.disable()
    }
    
    // MARK: - Keyboard Notifications
    @objc override func keyboardWillAppear(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
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
    
    // MARK: - IBActions
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        if tfValue.text != nil && !tfValue.text!.isEmpty {
            performSegue(withIdentifier: "valueVCSegue", sender: nil)
        }
    }
    
    @IBAction func quantityUnwindSegue(_ unwindSegue: UIStoryboardSegue) { }
    
}


extension QuantityVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let swiftRange = Range(range, in: text) {
            let valueStr = text.replacingCharacters(in: swiftRange, with: string)
            if let value = Double(valueStr.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".")), value > 0.0 {
                btnContinue.enable()
            } else {
                btnContinue.disable()
            }
        }
        
        if BXCardApp.instance.fleetProduct?.product?.productType == ProductType.combustivel {
            BBRealTimeCurrencyFormatter.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
            return false
        }
        return true
    }
    
}
