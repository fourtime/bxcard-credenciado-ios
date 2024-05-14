//
//  NotificationVC.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationVC: BaseVC {

    // MARK: - IBOutlets
    @IBOutlet weak var btnActivateNotification: Button!
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    override func configureScreen() {
        btnActivateNotification.applyGradient(withColours: Constants.COLORS._GRADIENT_ENABLED_COLORS, gradientOrientation: .horizontal)
    }
    
    private func registerForNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        self.closeNotificationVC()
                    }
                    
                } else {
                    debugPrint(error ?? "")
                }
            }
            
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            closeNotificationVC()
        }
    }
    
    private func closeNotificationVC() {
        performSegue(withIdentifier: "initializeVCSegue", sender: nil)
    }
    
    // MARK: - IBActions
    @IBAction func didTapActiveNotificationsButton(_ sender: UIButton) {
        registerForNotifications()
    }
    
    @IBAction func didTapNotNowButton(_ sender: UIButton) {
        closeNotificationVC()
    }
    
}
