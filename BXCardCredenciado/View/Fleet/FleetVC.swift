//
//  FleetVC.swift
//  BXCard
//
//  Created by Daive Simões on 22/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FleetVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var tfCode: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    private var selectedProduct: Product?
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
        
        BXCardApp.instance.fleetProductList.removeAll()
        BXCardApp.instance.fleetProduct = ProductItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = false
        tfCode.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enableAutoToolbar = true
        tfCode.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codeListVCSegue", let codeListVC = segue.destination as? CodeListVC {
            codeListVC.delegate = self
            
        } else if segue.identifier == "quantityVCSegue", let _ = segue.destination as? QuantityVC {
            selectedProduct = ProductService.instance.getProductBy(id: Int(self.tfCode.text!)!)
            BXCardApp.instance.fleetProduct?.product = selectedProduct
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
        
        tfCode.clear()
        btnContinue.disable()
    }
    
    // MARK: - IBActions
    @IBAction func fleetNewProductUnwindAction(_ unwindSegue: UIStoryboardSegue) {
        BXCardApp.instance.fleetProduct = ProductItem()
        selectedProduct = nil
        tfCode.clear()
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        if tfCode.text != nil && !tfCode.text!.isEmpty {
            performSegue(withIdentifier: "quantityVCSegue", sender: nil)
        }
    }
    
    @IBAction func fleetUnwindAction(_ unwindSegue: UIStoryboardSegue) { }
    
}


// MARK: - CodeListSelectDelegate
extension FleetVC: CodeListSelectDelegate {
    
    func didSelect(product: Product) {
        selectedProduct = product
        tfCode.text = "\(product.id)"
        btnContinue.enable()
        performSegue(withIdentifier: "quantityVCSegue", sender: nil)
    }
    
}


// MARK: - UITextFieldDelegate
extension FleetVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let swiftRange = Range(range, in: text) {
            let valueStr = text.replacingCharacters(in: swiftRange, with: string)
            if let value = Int(valueStr), value > 0 {
                btnContinue.enable()
            } else {
                btnContinue.disable()
            }
        }
        return true
    }
    
}
