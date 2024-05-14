//
//  TransactionVC.swift
//  BXCard
//
//  Created by Daive Simões on 31/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class TransactionsVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var lbSalesTotal: UILabel!
    @IBOutlet weak var lbAverageTicket: UILabel!
    @IBOutlet weak var tvTransactions: UITableView!
    @IBOutlet weak var lbNoRecords: UILabel!
    @IBOutlet weak var aiIndicator: UIActivityIndicatorView!
    
    // MARK: - Public Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private Properties
    private var connected = false
    private var transactionsSummary = [TransactionSummary]()
    private var transactionsDict: [String : [SyntheticTransaction]]!
    private var transactionsQty = 0
    private var lastUpdate = Date()
    private var refreshView: RefreshView!
    private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.clear
        refresh.tintColor = UIColor.clear
        refresh.addTarget(self, action: #selector(loadTransactions), for: .valueChanged)
        return refresh
    }()
    
    
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
        } else {
            loadTransactions()
        }
    }
    
    @objc override func lostConnection(_ notification: Notification) {
        checkConnection()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "transactionDetailVCSegue", let detailsVC = segue.destination as? TransactionDetailVC {
            detailsVC.delegate = self
            detailsVC.syntheticTransactions = sender as? [SyntheticTransaction]
        }
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        aiIndicator.startAnimating()
        
        //tvTransactions.isHidden = true
        //tvTransactions.alpha = 0.0
        
        lbNoRecords.isHidden = true
        
        vwHeader.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        vwTop.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        
        configureRefresh()
    }
    
    private func updateRefreshInfo() {
        let lastUpdateMessage = "Última atualização: \(Utils.formatDate(date: self.lastUpdate, withOutFormat: Constants.MASKS._LAST_UPDATE))"
        refreshView.lbUpdate.text = lastUpdateMessage
    }
    
    private func configureRefresh() {
        if let refreshView = Bundle.main.loadNibNamed("RefreshView", owner: self, options: nil)?.first as? RefreshView {
            self.refreshView = refreshView
            self.refreshView.frame = refreshControl.frame
            refreshControl.addSubview(self.refreshView)
            
            if #available(iOS 10.0, *) {
                tvTransactions.refreshControl = refreshControl
            } else {
                tvTransactions.addSubview(refreshControl)
            }
        }
        
        updateRefreshInfo()
    }
    
    private func updateTableView() {
        transactionsSummary = transactionsSummary.sorted(by: { $0.date > $1.date })
        updateSummary()
        tvTransactions.reloadData()
        
        //tvTransactions.isHidden = transactionsSummary.count == 0
        //lbNoRecords.isHidden = !tvTransactions.isHidden
        
        if !tvTransactions.isHidden {
            UIView.animate(withDuration: 0.5) {
                self.tvTransactions.alpha = 1.0
            }
        }
    }
    
    private func updateSummary() {
        let salesTotal = transactionsSummary.reduce(0, { $0 + $1.value })
        let averageTicket = transactionsQty == 0 ? 0.0 : salesTotal / Double(transactionsQty)
        lbSalesTotal.text = Utils.formatCurrency(value: salesTotal, "R$ ")
        lbAverageTicket.text = Utils.formatCurrency(value: averageTicket, "R$ ")
    }
    
    @objc private func loadTransactions() {
        if let initialDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date(), wrappingComponents: false) {
            TransactionService.instance.getSyntheticTransactions(withBeginDate: initialDate, andEndDate: Date()) { (transactions, error) in
                if let _ = error {
                    self.refreshControl.endRefreshing()
                    self.aiIndicator.stopAnimating()
                    self.showGenericErrorAlert(forController: self)
                    
                } else {
                    if let transactions = transactions, transactions.count > 0 {
                        self.transactionsQty = transactions.count
                        
                        self.transactionsSummary.removeAll()
                        self.transactionsDict = Dictionary(grouping: transactions, by: { $0.onlyDate })
                        for (date, transactions) in self.transactionsDict {
                            let totalValue = (transactions as [SyntheticTransaction]).reduce(0, { $0 + $1.valor} )
                            self.transactionsSummary.append(TransactionSummary(date: date, value: totalValue))
                        }
                        
                        self.updateTableView()
                    }
                    
                    self.lastUpdate = Date()
                    self.updateRefreshInfo()
                    self.refreshControl.endRefreshing()
                    self.aiIndicator.stopAnimating()
                }
            }
        }
    }
    
    private func tryToReconect() {
        if !ConnectivityService.instance.isConnected {
            checkConnection()
            
        } else {
            TerminalService.instance.login { (granted) in
                if granted {
                    self.loadTransactions()
                    
                } else {
                    self.checkConnection()
                }
            }
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        closeViewController()
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension TransactionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionsSummary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell {
            let summary = self.transactionsSummary[indexPath.row]
            cell.configure(withTransactionSummary: summary)
            return cell
        }
        
        return TransactionCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let summary = transactionsSummary[indexPath.row]
        let transactions = transactionsDict[summary.date]
        performSegue(withIdentifier: "transactionDetailVCSegue", sender: transactions)
    }

}


// MARK: - AlertDelegate
extension TransactionsVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if result == .right, id == "tryNewConnectionAlert" {
            tryToReconect()
        }
    }
    
}


// MARK: - NeedRefreshDelegate
extension TransactionsVC: NeedRefreshDelegate {
    
    func refreshNeeded() {
        loadTransactions()
    }
    
}
