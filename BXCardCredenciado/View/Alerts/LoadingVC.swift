//
//  LoadingController.swift
//  Vagow
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2018 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

class LoadingVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var aiIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lbMessage: UILabel!

    // MARK: - Public Properties
    var showing: Bool = false
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func show(_ message: String? = nil) {
        if !showing {
            showing = true
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.bringSubviewToFront(view)
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 8
            paragraphStyle.alignment = .center
    
            let attributedString: NSMutableAttributedString
            if let message = message {
                attributedString = NSMutableAttributedString(string: message)
            } else {
                attributedString = NSMutableAttributedString(string: "Aguarde...")
            }
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSMakeRange(0, attributedString.length))
            lbMessage.attributedText = attributedString
            
            view.alpha = 0.0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 1.0
            })
        }
    }
    
    func hide(){
        showing = false
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        })
    }
    
}
