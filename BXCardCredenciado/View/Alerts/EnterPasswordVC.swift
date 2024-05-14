//
//  EnterPasswordVC.swift
//  BXCard
//
//  Created by Daive Simões on 27/03/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

// MARK: - Protocols
protocol AccessPasswordDelegate: class {
    func didAuthenticated(sender: Any?)
}

class EnterPasswordVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var container: ShadowedView!
    @IBOutlet weak var tfPassword: TextField!
    @IBOutlet weak var btnConfirm: Button!
    @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var vwError: ShadowedView!
    
    // MARK: - Private Properties
    private var defaultBottomConstraint: CGFloat!
    private var currentTopConstraint: CGFloat!
    
    // MARK: - Public Properties
    weak var delegate: AccessPasswordDelegate?
    var statusBarStyle: UIStatusBarStyle?
    var sender: Any?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle ?? .lightContent
    }
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDialog()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        openContainer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        tfPassword.resignFirstResponder()
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
    
    private func configureDialog() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        defaultBottomConstraint = containerBottomConstraint.constant
        
        currentTopConstraint = errorTopConstraint.constant
        errorTopConstraint.constant = (vwError.frame.height + currentTopConstraint) * -1.0
        
        container.isHidden = true
        btnConfirm.disable()
    }
    
    private func openContainer() {
        container.center.y += container.frame.height
        container.isHidden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.container.center.y -= self.container.frame.height
        }) { (_) in
            self.tfPassword.becomeFirstResponder()
        }
    }
    
    private func closeContainer(withCompletion completion: Completion) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.endEditing(true)
        }) { (_) in
            completion?()
        }
    }
    
    private func authenticate() {
        if DataService.instance.userLoginPassword != tfPassword.text! {
            view.endEditing(true)
            updateErrorInfo(showErrorPanel: true)
            
        } else {
            closeContainer {
                self.dismiss(animated: false, completion: {
                    self.delegate?.didAuthenticated(sender: self.sender)
                })
            }
        }
    }
    
    // MARK: - Keyboard Notifications
    @objc func keyboardWillAppear(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: duration, animations: {
            self.containerBottomConstraint.constant = keyboardFrame.height + self.defaultBottomConstraint
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        view.layoutIfNeeded()
        UIView.animate(withDuration: duration, animations: {
            self.containerBottomConstraint.constant = self.defaultBottomConstraint
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - IBActions
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let password = tfPassword.text?.trimmingCharacters(in: .whitespaces), !password.isEmpty {
            btnConfirm.enable()
        } else {
            btnConfirm.disable()
        }
    }
    
    @IBAction func didTapCloseErrorPanelButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        updateErrorInfo(showErrorPanel: false)
        closeContainer {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        authenticate()
    }
    
}


// MARK: - UITextFieldDelegate
extension EnterPasswordVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateErrorInfo(showErrorPanel: false)
    }
    
}
