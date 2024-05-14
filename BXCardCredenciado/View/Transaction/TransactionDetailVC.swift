//
//  TransactionDetailVC.swift
//  BXCard
//
//  Created by Daive Simões on 05/02/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

// MARK: - Protocols
protocol NeedRefreshDelegate: class {
    func refreshNeeded()
}

class TransactionDetailVC: BaseVC {
    
    // MARK: - IBOutlets
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var lbSummaryDate: UILabel!
    @IBOutlet weak var lbSummaryDay: UILabel!
    @IBOutlet weak var lbSummaryValue: UILabel!
    @IBOutlet weak var tvDetails: UITableView!
    
    // MARK: - Public Properties
    var syntheticTransactions: [SyntheticTransaction]!
    private var transactions: [AnalyticTransaction]?
    weak var delegate: NeedRefreshDelegate?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private Properties
    private var needRefresh = false
    private var currentDateStr = ""
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
        
        needRefresh = false
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        configureHeader()
        configureRefresh()
        
        syntheticTransactions = syntheticTransactions.sorted(by: { $0.data > $1.data })
        
        self.loadTransactions()
    }
    
    private func configureHeader() {
        currentDateStr = syntheticTransactions.first!.onlyDate
        lbSummaryDate.text = syntheticTransactions.first!.dayAndDescriptiveMonth
        lbSummaryDay.text = Utils.getDayName(fromDate: syntheticTransactions.first!.data.toDate(withInFormat: Constants.MASKS._DEFAULT_DATE_TIME))
        lbSummaryValue.text = Utils.formatCurrency(value: syntheticTransactions.reduce(0, { $0 + $1.valor }), "R$ ")
        
        vwHeader.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
        vwTop.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
    }
    
    private func updateRefreshInfo() {
        let lastUpdateMessage = "Última atualização: \(Utils.formatDate(date: lastUpdate, withOutFormat: Constants.MASKS._LAST_UPDATE))"
        refreshView.lbUpdate.text = lastUpdateMessage
    }
    
    private func configureRefresh() {
        if let refreshView = Bundle.main.loadNibNamed("RefreshView", owner: self, options: nil)?.first as? RefreshView {
            self.refreshView = refreshView
            self.refreshView.frame = refreshControl.frame
            refreshControl.addSubview(self.refreshView)
            
            if #available(iOS 10.0, *) {
                tvDetails.refreshControl = refreshControl
            } else {
                tvDetails.addSubview(refreshControl)
            }
        }
        
        updateRefreshInfo()
    }
    
    @objc private func loadTransactions() {
        if let initialDate = Calendar.current.date(byAdding: Calendar.Component.month, value: -1, to: Date(), wrappingComponents: false) {
            TransactionService.instance.getAnalyticTransactions(withBeginDate: initialDate, andEndDate: Date()) { (transactions, error) in
                if let _ = error {
                    self.refreshControl.endRefreshing()
                    self.showGenericErrorAlert(forController: self)
                } else {
                    if let transactions = transactions {
                        let transactionsDict = Dictionary(grouping: transactions, by: { $0.onlyDate })
                        self.transactions = transactionsDict[self.currentDateStr]
                        self.lastUpdate = Date()
                        self.updateRefreshInfo()
                        self.refreshControl.endRefreshing()
                        self.transactions = self.transactions?.sorted(by: { $0.transactionDate > $1.transactionDate })
                        self.tvDetails.reloadData()
                        
                        self.needRefresh = true
                    }
                }
            }
        }
    }
    
    private func cancelTransaction(_ transaction: AnalyticTransaction) {
        TransactionService.instance.cancel(transaction: transaction) { (error) in
            if let e = error {
                self.showErrorAlert(forController: self, message: (e as NSError).domain)
            } else {
                if let index = self.transactions?.firstIndex(where: { $0.cardId == transaction.cardId }) {
                    self.transactions?.remove(at: index)
                    self.tvDetails.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
                    
                    self.showAlert(forController: self, message: "Compra cancelada com sucesso", messageImage: Constants.IMAGES._CHECK_GREEN_IMAGE, messageAlignment: .center, leftButtonTitle: nil, rightButtonTitle: "Concluir", withId: "", sender: nil)
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func didTapBackButton(_ sender: UIButton) {
        if needRefresh {
          delegate?.refreshNeeded()
        }
        
        closeViewController()
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension TransactionDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let transaction = self.transactions?[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDetailCell") as? TransactionDetailCell {
            cell.configure(forController: self, withTransaction: transaction)
            return cell
        }
        
        return TransactionDetailCell()
    }
    
}


// MARK: - AlertDelegate
extension TransactionDetailVC: AlertDelegate {
    
    func didPressAlertButton(withResult result: AlertResult, forId id: String, sender: Any?) {
        if id == "deleteConfirmedAlert", result == .right, let transaction = sender as? AnalyticTransaction {
            showEnterPasswordDialog(forController: self, sender: transaction)
        }
    }
    
}


// MARK: - AccessPasswordDelegate
extension TransactionDetailVC: AccessPasswordDelegate {
    
    func didAuthenticated(sender: Any?) {
        if let transaction = sender as? AnalyticTransaction {
            cancelTransaction(transaction)
        }
    }
    
}
