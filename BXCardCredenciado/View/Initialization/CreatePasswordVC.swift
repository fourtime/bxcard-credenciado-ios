//
//  CreatePasswordVC.swift
//  BXCard
//
//  Created by Daive Simões on 08/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class CreatePasswordVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var tfPassword: TextField!
    @IBOutlet weak var tfConfirmation: TextField!
    @IBOutlet weak var btnCreatePassword: Button!
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    private var currentTopConstraint: CGFloat!
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tfPassword.becomeFirstResponder()
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        btnCreatePassword.disable()
        tfPassword.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        currentTopConstraint = errorTopConstraint.constant
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
    }
    
    @objc override func keyboardWillAppear(_ notification: Notification) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    // MARK: - Private Methods
    @objc private func doneButtonClicked() {
        if let password = tfPassword.text, !password.isEmpty {
            tfConfirmation.becomeFirstResponder()
        }
    }
    
    private func updateErrorInfo(showErrorPanel show: Bool) {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            if show {
                self.errorTopConstraint.constant = self.currentTopConstraint
            } else {
                self.errorTopConstraint.constant = (self.vwError.frame.height + self.currentTopConstraint) * -1.0
            }
            self.view.layoutIfNeeded()
        })
        
        if show {
            tfPassword.borderColor = UIColor.errorBorderColor
            tfPassword.rightImage = Constants.IMAGES._ERROR_ICON
            tfConfirmation.borderColor = UIColor.errorBorderColor
            tfConfirmation.rightImage = Constants.IMAGES._ERROR_ICON
            
        } else {
            tfPassword.borderColor = UIColor.defaultBorderColor
            tfPassword.rightImage = nil
            tfConfirmation.borderColor = UIColor.defaultBorderColor
            tfConfirmation.rightImage = nil
        }
    }
    
    private func validate() -> Bool {
        if let password = tfPassword.text?.trimmingCharacters(in: .whitespaces), let confirmation = tfConfirmation.text?.trimmingCharacters(in: .whitespaces), !password.isEmpty, password == confirmation {
            return true
        }
        
        return false
    }
    
    private func createPassword() {
        if !validate() {
            updateErrorInfo(showErrorPanel: true)
            return
        }
        
        DataService.instance.userLoginPassword = tfPassword.text!
        TerminalService.instance.login { (granted) in
            if granted {
                DataService.instance.isLoggedIn = true
                DataService.instance.isFirstAccess = false
                self.performSegue(withIdentifier: "selectionVCSegue", sender: nil)
                
            } else {
                self.showGenericErrorAlert(forController: self)
            }
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func textFieldEditingChange(_ sender: UITextField) {
        if let password = tfPassword.text, let confirmation = tfConfirmation.text, !password.isEmpty, !confirmation.isEmpty {
            btnCreatePassword.enable()
        } else {
            btnCreatePassword.disable()
        }
    }
    
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @IBAction func didTapCreatePasswordButton(_ sender: UIButton) {
        createPassword()
    }
    
}
