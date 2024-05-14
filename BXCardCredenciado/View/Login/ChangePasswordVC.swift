//
//  ChangePasswordVC.swift
//  BXCard
//
//  Created by Daive Simões on 12/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var tfOldPassword: TextField!
    @IBOutlet weak var tfNewPassword: TextField!
    @IBOutlet weak var tfConfirmation: TextField!
    @IBOutlet weak var btnChangePassword: Button!
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var lbErrorMessage: UILabel!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    private var currentTopConstraint: CGFloat!
    
    // MARK: - Public Properties
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        vwError.isHidden = true
        
        tfOldPassword.clear()
        tfNewPassword.clear()
        tfConfirmation.clear()
        
        currentTopConstraint = errorTopConstraint.constant
        btnChangePassword.disable()
        
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        vwError.isHidden = false
    }
    
    @objc override func keyboardWillAppear(_ notification: Notification) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    // MARK: - Private Methods
    private func updateErrorInfo(showErrorPanel show: Bool, withMessage message: String = "") {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            if show {
                self.errorTopConstraint.constant = self.currentTopConstraint
            } else {
                self.errorTopConstraint.constant = (self.vwError.frame.height + self.currentTopConstraint) * -1.0
            }
            self.view.layoutIfNeeded()
        })
        
        lbErrorMessage.text = message
        
        if show {
            tfOldPassword.borderColor = UIColor.errorBorderColor
            tfOldPassword.rightImage = Constants.IMAGES._ERROR_ICON
            tfNewPassword.borderColor = UIColor.errorBorderColor
            tfNewPassword.rightImage = Constants.IMAGES._ERROR_ICON
            tfConfirmation.borderColor = UIColor.errorBorderColor
            tfConfirmation.rightImage = Constants.IMAGES._ERROR_ICON
            
        } else {
            tfOldPassword.borderColor = UIColor.defaultBorderColor
            tfOldPassword.rightImage = nil
            tfNewPassword.borderColor = UIColor.defaultBorderColor
            tfNewPassword.rightImage = nil
            tfConfirmation.borderColor = UIColor.defaultBorderColor
            tfConfirmation.rightImage = nil
        }
    }
    
    private func validate() -> Bool {
        if tfOldPassword.text! != DataService.instance.userLoginPassword {
            updateErrorInfo(showErrorPanel: true, withMessage: "A senha atual informada está incorreta.")
            return false
        }
        
        if tfNewPassword.text! != tfConfirmation.text! {
            updateErrorInfo(showErrorPanel: true, withMessage: "A nova senha e sua confirmação não conferem.")
            return false
        }
        
        return true
    }
    
    private func close() {
        vwError.isHidden = true
        closeViewController()
    }
    
    private func changePassword() {
        updateErrorInfo(showErrorPanel: false)
        
        if !validate() {
            return
        }
        
        DataService.instance.userLoginPassword = self.tfNewPassword.text!
        
        showAlert(forController: self, message: "Senha alterada com sucesso", messageImage: Constants.IMAGES._CHECK_GREEN_IMAGE, messageAlignment: .center, leftButtonTitle: nil, rightButtonTitle: "Concluir", canCloseClickingOutside: false, withId: "passwordChangedAlert", sender: nil)
    }
    
    // MARK: - IBActions
    @IBAction func textFieldEditingChanged(_ sender: TextField) {
        if let oldPassword = tfOldPassword.text, let newPassword = tfNewPassword.text, let confirmation = tfConfirmation.text, !oldPassword.isEmpty, !newPassword.isEmpty, !confirmation.isEmpty {
            btnChangePassword.enable()
        } else {
            btnChangePassword.disable()
        }
    }
    
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @IBAction func didTapChangePasswordButton(_ sender: UIButton) {
        changePassword()
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        close()
    }
    
    @IBAction func doShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.tag == 1 {
            tfNewPassword.isSecureTextEntry.toggle()
        } else if sender.tag == 2 {
            tfConfirmation.isSecureTextEntry.toggle()
        } else {
            tfOldPassword.isSecureTextEntry.toggle()
        }
    }
}


// MARK: - AlertDelegate
extension ChangePasswordVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right && id == "passwordChangedAlert" {
            close()
        }
    }
    
}
