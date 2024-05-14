//
//  MenuVC.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import SafariServices

class MenuVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lbAssociatedName: UILabel!
    @IBOutlet weak var lbCNPJNumber: UILabel!
    @IBOutlet weak var lbTerminalCode: UILabel!
    
    // MARK: - Public Properties
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Private Methods
    private func loadTerminalData() {
        lbAssociatedName.text = DataService.instance.terminal?.corporateName
        lbCNPJNumber.text = Utils.mask(text: DataService.instance.terminal?.cnpj, withMask: Constants.MASKS._CNPJ)
        lbTerminalCode.text = "Terminal: \(DataService.instance.terminalCode)"
    }
    
    private func showTransactions() {
        revealViewController()?.revealToggle(animated: true)
        performSegue(withIdentifier: "transactionVCSegue", sender: nil)
    }
    
    private func requestAttendance() {
        if let contactUrl = DataService.instance.terminalContact, let safariVC = Utils.getSafariController(withURL: contactUrl) {
            safariVC.delegate = self
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    private func changePassword() {
        revealViewController()?.revealToggle(animated: true)
        performSegue(withIdentifier: "changePasswordVCSegue", sender: nil)
    }
    
    private func logout() {
        DataService.instance.isLoggedIn = false
        revealViewController()?.revealToggle(animated: false)
        (revealViewController()?.frontViewController as? UINavigationController)?.popToRootViewController(animated: true)
    }
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTerminalData()
    }
    
    // MARK: - IBActions
    @IBAction func didTapTransactionButton(_ sender: UIButton) {
        showTransactions()
    }
    
    @IBAction func didTapAttendanceButton(_ sender: UIButton) {
        requestAttendance()
    }
    
    @IBAction func didTapChangePasswordButton(_ sender: UIButton) {
        changePassword()
    }
    
    @IBAction func didTapExitButton(_ sender: UIButton) {
        logout()
    }
    
}


// MARK: - SFSafariViewControllerDelegate
extension MenuVC: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        revealViewController()?.revealToggle(animated: true)
    }
    
}
