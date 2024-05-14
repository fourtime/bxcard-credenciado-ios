//
//  OdometerVC.swift
//  BXCard
//
//  Created by Daive Simões on 28/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class OdometerVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var tfValue: UITextField!
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
        if segue.identifier == "conductorVCSegue", let _ = segue.destination as? ConductorVC {
            BXCardApp.instance.fleetTransaction?.odometer = Int(tfValue.text!)
        }
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        super.configureScreen()
        
        tfValue.clear()
        
        btnContinue.disable()
    }
    
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

    // MARK: - IBActions
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        if let value = tfValue.text, let odometer = Int(value), odometer > 0 {
            performSegue(withIdentifier: "conductorVCSegue", sender: nil)
        }
    }
    
    @IBAction func odometerUnwindAction(_ unwindSegue: UIStoryboardSegue) { }
    
}


// MARK: - UITextFieldDelegate
extension OdometerVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let swiftRange = Range(range, in: text) {
            let valueStr = text.replacingCharacters(in: swiftRange, with: string)
            if let value = Int(valueStr), value > 0 {
                btnContinue.enable()
            } else {
                btnContinue.disable()
            }
        }
        
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 10
    }
    
}
