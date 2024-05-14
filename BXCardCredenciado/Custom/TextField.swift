//
//  TextField.swift
//  Vagow
//
//  Created by Daive Simões on 27/11/18.
//  Copyright © 2018 Fourtime Informática Ltda. All rights reserved.
//
import UIKit

@IBDesignable
class TextField: UITextField {
    
    // MARK: - Public Properties
    @IBInspectable
    var borderColor: UIColor = UIColor.clear{
        didSet{
            setupView()
        }
    }
    
    @IBInspectable
    var bottomBorderColor: UIColor = UIColor.clear {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var bottomBorderWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var leftImage: UIImage? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var leftImageHeight: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var leftImageWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var leftPadding: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var placeholderColor: UIColor = UIColor.clear{
        didSet{
            setupView()
        }
    }
    
    @IBInspectable
    var rightImage: UIImage? {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var rightImageHeight: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var rightImageWidth: CGFloat = 0.0 {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    var rightPadding: CGFloat = 0.0 {
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
            borderStyle = .none
            
            let border = CALayer()
            border.borderColor = bottomBorderColor.cgColor
            border.frame = CGRect(x: 0, y: frame.size.height - bottomBorderWidth, width: frame.size.width, height: frame.size.height)
            border.borderWidth = bottomBorderWidth
            layer.addSublayer(border)
            layer.masksToBounds = true
        }
    }
    
    private func setupLeftImage() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: leftImageWidth + leftPadding, height: frame.height))
        
        if let leftImage = leftImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: leftImageWidth, height: leftImageHeight))
            imageView.image = leftImage
            container.addSubview(imageView)
            imageView.center = container.center
        }
        
        leftViewMode = UITextField.ViewMode.always
        leftView = container

    }
    
    private func setupRightImage() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: rightImageWidth + rightPadding, height: frame.height))
        
        if let rightImage = rightImage {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: rightImageWidth, height: rightImageHeight))
            imageView.image = rightImage
            container.addSubview(imageView)
            imageView.center = container.center
        }
            
        rightViewMode = UITextField.ViewMode.always
        rightView = container
    }
    
    private func setupView() {
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        attributedPlaceholder = NSAttributedString(string: (placeholder != nil) ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        
        setupLeftImage()
        setupRightImage()
        setupBottomBorder()
    }
    
}
