//
//  SelectionVC.swift
//  BXCard
//
//  Created by Daive Simões on 22/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class SelectionVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var postPaidView: ShadowedView!
    @IBOutlet weak var prePaidView: ShadowedView!
    @IBOutlet weak var fleetView: ShadowedView!
    
    // MARK: - Public Properties
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cardVC = segue.destination as? CardVC {
            if segue.identifier == "postPaidCardVCSegue"  {
                cardVC.selectedCardType = .postPaid
            } else {
                cardVC.selectedCardType = .prePaid
            }
        }
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        configureRevealMenu(btnMenu)
        setAcceptedCards()
    }
    
    private func setAcceptedCards() {
        postPaidView.isHidden = !DataService.instance.acceptedCards.contains(CardType.postPaid.rawValue)
        prePaidView.isHidden = !DataService.instance.acceptedCards.contains(CardType.prePaid.rawValue)
        fleetView.isHidden = !DataService.instance.acceptedCards.contains(CardType.fleet.rawValue)
    }
    
    // MARK: - IBActions
    @IBAction func selectionUnwindAction(unwindSegue: UIStoryboardSegue) { }

}
