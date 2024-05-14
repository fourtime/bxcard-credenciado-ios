//
//  Button.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit


@IBDesignable
class Button: UIButton {
    
    // MARK: - Public Properties
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var shadowColor: UIColor? = UIColor.clear {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var shadowOpacity:  Float = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    // MARK: - Initilization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    // MARK: - Private Methods
    func setupView() {
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
    }
    
}


// MARK: - Extensions
extension Button {
    
    func enable() {
        isEnabled = true
        /*
        BXCardApp.instance.disabledGradient.removeFromSuperlayer()
        BXCardApp.instance.defaultGradient.removeFromSuperlayer()
        BXCardApp.instance.defaultGradient.frame = bounds
        BXCardApp.instance.defaultGradient.colors = Constants.COLORS._GRADIENT_ENABLED_COLORS.map { $0.cgColor }
        BXCardApp.instance.defaultGradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        BXCardApp.instance.defaultGradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
         */
        //layer.insertSublayer(BXCardApp.instance.defaultGradient, at: 0)
        backgroundColor = .enabledDegradeDarkColor
    }
    
    func disable() {
        isEnabled = false
        /*
        BXCardApp.instance.defaultGradient.removeFromSuperlayer()
        BXCardApp.instance.disabledGradient.removeFromSuperlayer()
        BXCardApp.instance.disabledGradient.frame = bounds
        BXCardApp.instance.disabledGradient.colors = Constants.COLORS._GRADIENT_DISABLED_COLORS.map { $0.cgColor }
        BXCardApp.instance.disabledGradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        BXCardApp.instance.disabledGradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
         */
        //layer.insertSublayer(BXCardApp.instance.disabledGradient, at: 0)
        backgroundColor = .disabledDegradeDarkColor
    }
    
}

