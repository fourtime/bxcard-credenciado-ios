//
//  ViewController.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CardVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    var selectedCardType: CardType?
    
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
        if segue.identifier == "parcelsVCSegue", let parcelsVC = segue.destination as? ParcelsVC {
            parcelsVC.value = Double(tfValue.text!.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespacesAndNewlines))
            
        } else if segue.identifier == "prePaidQRCodeVCSegue", let qrCodeVC = segue.destination as? CardQRCodeVC {
            qrCodeVC.parcelsNumber = 1
            qrCodeVC.totalValue = Double(tfValue.text!.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespacesAndNewlines))
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
    
    // MARK: - Private Methods
    override func configureScreen() {
        super.configureScreen()
        
        tfValue.text = "0,00"
        
        btnContinue.disable()
    }
    
    private func isPostPaidCardSelected() -> Bool {
        return selectedCardType == .postPaid
    }
    
    // MARK: - IBActions
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        if isPostPaidCardSelected() {
            performSegue(withIdentifier: "parcelsVCSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "prePaidQRCodeVCSegue", sender: nil)
        }
    }
    
    @IBAction func cardUnwindAction(unwindSegue: UIStoryboardSegue) { }
    
}


// MARK: - UITextFieldDelegate
extension CardVC: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let swiftRange = Range(range, in: text) {
            let valueStr = text.replacingCharacters(in: swiftRange, with: string).replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespacesAndNewlines)
            if let value = Double(valueStr), value > 0.0 {
                btnContinue.enable()
            } else {
                btnContinue.disable()
            }
        }
        
        BBRealTimeCurrencyFormatter.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        return false
    }

}

