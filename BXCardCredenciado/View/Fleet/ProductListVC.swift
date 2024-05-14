//
//  ProductListVC.swift
//  BXCard
//
//  Created by Daive Simões on 28/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class ProductListVC: BaseVC {

    // MARK: IBOutlets
    @IBOutlet weak var tvProducts: UITableView!
    @IBOutlet weak var lbTotalValue: UILabel!
    @IBOutlet weak var btnContinue: Button!
    @IBOutlet weak var vwProducts: ShadowedView!
    @IBOutlet weak var vwNoProducts: UIView!
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BXCardApp.instance.fleetProductList.append(BXCardApp.instance.fleetProduct!)
        
        updateRecordsView()
        updateTotalValue()
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        btnContinue.disable()
    }
   
    private func confirmCancel() {
        self.showAlert(forController: self, title: "Cancelar operação", message: "Deseja realmente cancelar a operação?", leftButtonTitle: "Fechar", leftButtonType: .normal, leftButtonBorderColor: nil, rightButtonTitle: "Cancelar", rightButtonType: .destructive, rightButtonBorderColor: nil, closeButtonImage: Constants.IMAGES._CLOSE_GRAY_ICON, withId: "cancelConfirmAlert", sender: nil)
    }
    
    private func cancel() {
        performSegue(withIdentifier: "selectionUnwindSegue", sender: nil)
    }
    
    private func delete(productItem: ProductItem) {
        if let deleteIndex = BXCardApp.instance.fleetProductList.firstIndex(where: { $0.product!.id == productItem.product!.id}) {
            BXCardApp.instance.fleetProductList.remove(at: deleteIndex)
            tvProducts.deleteRows(at: [IndexPath(item: deleteIndex, section: 0)], with: .automatic)
            updateTotalValue()
            updateRecordsView()
        }
    }
    
    private func updateTotalValue() {
        let total = BXCardApp.instance.fleetProductList.reduce(0, { $0 + ($1.value ?? 0.0) })
        lbTotalValue.text = Utils.formatCurrency(value: total, "R$ ")
        
        if BXCardApp.instance.fleetProductList.count == 0 {
            btnContinue.disable()
        } else {
            btnContinue.enable()
        }
    }
    
    private func updateRecordsView() {
        vwProducts.isHidden = BXCardApp.instance.fleetProductList.isEmpty
        vwNoProducts.isHidden = !vwProducts.isHidden
    }
    
    // MARK: - IBActions
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        confirmCancel()
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {
        if BXCardApp.instance.fleetProductList.count > 0 {
            if BXCardApp.instance.fleetTransaction == nil {
                BXCardApp.instance.fleetTransaction = FleetTransaction()
            }
            
            BXCardApp.instance.fleetTransaction?.products = BXCardApp.instance.fleetProductList
            performSegue(withIdentifier: "odometerVCSegue", sender: nil)
        }
    }
    
    @IBAction func productListUnwindAction(_ unwindSegue: UIStoryboardSegue) { }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProductListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BXCardApp.instance.fleetProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "productItemCell") as? ProductItemCell {
            let productItem = BXCardApp.instance.fleetProductList[indexPath.row]
            cell.configure(withProductItem: productItem, forController: self)
            return cell
        }
        
        return ProductItemCell()
    }
    
}


// MARK: - AlertDelegate
extension ProductListVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right {
            if id == "deleteProductItemAlert", let productItem = sender as? ProductItem {
                delete(productItem: productItem)
                
            } else if id == "cancelConfirmAlert" {
                cancel()
            }
        }
    }
    
}
