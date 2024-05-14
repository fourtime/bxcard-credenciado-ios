//
//  CodeListVC.swift
//  BXCard
//
//  Created by Daive Simões on 25/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

// MARK: - Protocol
protocol CodeListSelectDelegate: class {
    func didSelect(product: Product)
}

class CodeListVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: ShadowedView!
    @IBOutlet weak var tvCodes: UITableView!
    
    // MARK: - Public Properties
    weak var delegate: CodeListSelectDelegate?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
        
        tvCodes.reloadData()
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        vwHeader.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .vertical)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        closeViewController()
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension CodeListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductService.instance.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCodeCell") as? ServiceCodeCell {
            let product = ProductService.instance.products[indexPath.row]
            cell.configure(withProduct: product)
            return cell
        }
        return ServiceCodeCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = ProductService.instance.products[indexPath.row]
        closeViewController(false)
        delegate?.didSelect(product: product)
    }
    
}
