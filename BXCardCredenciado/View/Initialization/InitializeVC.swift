//
//  LoginVC.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import InputMask

class InitializeVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet var cnpjListener: MaskedTextFieldDelegate!
    @IBOutlet var terminalListener: MaskedTextFieldDelegate!
    @IBOutlet weak var vwError: ShadowedView!
    @IBOutlet weak var lbErrorMessage: UILabel!
    @IBOutlet weak var tfCNPJ: TextField!
    @IBOutlet weak var tfTerminal: TextField!
    @IBOutlet weak var btnEnter: Button!
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
    
    // MARK: - Private Methods
    override func configureScreen() {
        super.configureScreen()
        
        btnEnter.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        
        currentTopConstraint = errorTopConstraint.constant
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
    }
    
    @objc override func keyboardWillAppear(_ notification: Notification) {
        updateErrorInfo(showErrorPanel: false)
    }
    
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
        
        if !message.isEmpty {
            lbErrorMessage.text = message
        }
        
        if show {
            tfCNPJ.borderColor = UIColor.errorBorderColor
            tfCNPJ.rightImage = Constants.IMAGES._ERROR_ICON
            tfTerminal.borderColor = UIColor.errorBorderColor
            tfTerminal.rightImage = Constants.IMAGES._ERROR_ICON
            
        } else {
            tfCNPJ.borderColor = UIColor.defaultBorderColor
            tfCNPJ.rightImage = nil
            tfTerminal.borderColor = UIColor.defaultBorderColor
            tfTerminal.rightImage = nil
        }
    }
    
    private func validate() -> Bool {
        if let cnpj = tfCNPJ.text?.trimmingCharacters(in: .whitespaces), let terminal = tfTerminal.text?.trimmingCharacters(in: .whitespaces), !cnpj.isEmpty, !terminal.isEmpty, cnpj.onlyNumbers().count == 14, terminal.count == 8 {
            return true
        }
        
        return false
    }
    
    private func initialize() {
        if !validate() {
            updateErrorInfo(showErrorPanel: true)
            return
        }
        
        TerminalService.instance.initialize(withCNPJ: tfCNPJ.text!, andTerminal: tfTerminal.text!) { (loginResponse, error) in
            if let e = error as? NSError {
                self.updateErrorInfo(showErrorPanel: true, withMessage: e.domain)
            } else {
                CardService.instance.getAcceptedCards(withCompletion: { (result) in
                    if result {
                        self.performSegue(withIdentifier: "createPasswordVCSegue", sender: nil)
                        
                    } else {
                        self.showGenericErrorAlert(forController: self)
                    }
                })
                
                /*
                DataService.instance.accessToken = loginResponse?.token.accessToken ?? ""
                DataService.instance.accessTokenExpiration = Calendar.current.date(byAdding: .second, value: loginResponse?.token.expiresIn ?? 0, to: Date())
                DataService.instance.terminalCode = self.tfTerminal.text!
                
                TerminalService.instance.getTerminalData(withCompletion: { (result) in
                    if result {
                        CardService.instance.getAcceptedCards(withCompletion: { (result) in
                            if result {
                                self.performSegue(withIdentifier: "createPasswordVCSegue", sender: nil)
                                
                            } else {
                                self.showGenericErrorAlert(forController: self)
                            }
                        })
                    } else {
                        self.showGenericErrorAlert(forController: self)
                    }
                })*/
            }
        }
        
    }
    
    private func tryToReconect() {
        if !ConnectivityService.instance.isConnected {
            checkConnection()
            
        } else {
            TerminalService.instance.login { (granted) in
                if !granted {
                    self.checkConnection()
                }
            }
        }
    }
    
    private func help() {
        showAlert(forController: self, title: "Ajuda", message: "Para obter o número do terminal ou demais informações, entre em contato com a nossa central de atendimento.", leftButtonTitle: nil, leftButtonType: nil, leftButtonBorderColor: nil, rightButtonTitle: "Entrar em contato", rightButtonType: .normal, rightButtonBorderColor: nil, closeButtonImage: Constants.IMAGES._CLOSE_GRAY_ICON, withId: "needHelpAlert", sender: nil)
    }
    
    // MARK: - IBActions
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }

    @IBAction func didTapEnterButton(_ sender: UIButton) {
        initialize()
    }
    
    @IBAction func didTapNeedHelpButton(_ sender: UIButton) {
        help()
    }
    
}


// MARK: - AlertDelegate
extension InitializeVC: AlertDelegate {
    
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


// MARK: - MaskedTextFieldDelegateListener
extension InitializeVC: MaskedTextFieldDelegateListener {
    
    func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {

        if textField == self.tfCNPJ, let cnpj = self.tfCNPJ.text, cnpj.count == 18 {
            tfTerminal.becomeFirstResponder()
            
        } else if textField == self.tfTerminal, let terminal = self.tfTerminal.text, terminal.count == 8, let cnpj = self.tfCNPJ.text, !cnpj.isEmpty {
            hideKeyboard()
        }
    }
    
}
