//
//  ShadowedView.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowedView: UIView {
    
    // MARK: - Public Properties
    @IBInspectable var bottomBorderColor: UIColor = UIColor.clear {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable var bottomBorderWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
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
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupBottomBorder() {
        if bottomBorderWidth > 0 {
            let border = CALayer()
            border.borderColor = bottomBorderColor.cgColor
            border.frame = CGRect(x: 0, y: frame.size.height - bottomBorderWidth, width: frame.size.width, height: frame.size.height)
            border.borderWidth = bottomBorderWidth
            layer.addSublayer(border)
            layer.masksToBounds = true
        }
    }
    
    private func setupView() {
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        setupBottomBorder()
    }
    
}

