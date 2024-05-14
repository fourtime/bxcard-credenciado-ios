//
//  LoginVC.swift
//  BXCard
//
//  Created by Daive Simões on 08/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {

    // MARK: - IBOutlet
    @IBOutlet weak var tfPassword: TextField!
    @IBOutlet weak var btnEnter: Button!
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    private var currentTopConstraint: CGFloat!
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTopConstraint = errorTopConstraint.constant
        
        TerminalService.instance.getOperatorLinks()
        
        if DataService.instance.isFirstAccess {
            performSegue(withIdentifier: "initializeVCSegue", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureScreen()
        
        if !DataService.instance.isFirstAccess, DataService.instance.isLoggedIn {
            performSegue(withIdentifier: "autoLoginSegue", sender: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkConnection()
    }
    
    private func checkConnection() {
        if !ConnectivityService.instance.isConnected {
            showNetworkConnectionAlert(forController: self)
        }
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }
    
    override func configureScreen() {
        super.configureScreen()
        
        tfPassword.clear()
        btnEnter.disable()
        
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
    }
    
    @objc override func keyboardWillAppear(_ notification: Notification) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    // MARK: - Private Methods
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
            
        } else {
            tfPassword.borderColor = UIColor.defaultBorderColor
            tfPassword.rightImage = nil
        }
    }
    
    private func recoverPassword() {
        showAlert(forController: self, title: "Esqueci minha senha", message: "Caso você tenha esquecido sua senha e precisa de ajuda, entre em contato com a nossa central de atendimento.", leftButtonTitle: nil, leftButtonType: nil, leftButtonBorderColor: nil, rightButtonTitle: "Entrar em contato", rightButtonType: .normal, rightButtonBorderColor: nil, closeButtonImage: Constants.IMAGES._CLOSE_GRAY_ICON, withId: "needHelpAlert", sender: nil)
    }
    
    private func login() {
        if let password = tfPassword.text, DataService.instance.userLoginPassword == password {
            DataService.instance.isLoggedIn = true
            performSegue(withIdentifier: "selectionVCSegue", sender: nil)
            
        } else {
            updateErrorInfo(showErrorPanel: true)
        }
    }
    
    // MARK: - IBActions
    @IBAction func textFieldEditingChange(_ sender: UITextField) {
        if let password = self.tfPassword.text, !password.isEmpty, password.count == DataService.instance.userLoginPassword.count {
            btnEnter.enable()
            hideKeyboard()
        } else {
            btnEnter.disable()
        }
    }
    
    @IBAction func didTapEnterButton(_ sender: UIButton) {
        login()
    }
    
    @IBAction func didTapForgetPasswordButton(_ sender: UIButton) {
        recoverPassword()
    }

    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }
    
}


// MARK: - AlertDelegate
extension LoginVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right {
            if id == "needHelpAlert", let contactUrl = DataService.instance.terminalContact, let safariVC = Utils.getSafariController(withURL: contactUrl) {
                present(safariVC, animated: true, completion: nil)
                
            } else if id == "tryNewConnectionAlert" {
                checkConnection()
            }
        }
    }
    
}
