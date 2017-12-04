//
//  DesignableDynamicTextView.swift
//  TinkoffChat
//
//  Created by Kam Lotfull on 01/01/2017.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

@IBDesignable class DesignableDynamicTextView: UITextView, DesignableCorners, DesignableBorder {
    private static let defaultPlaceholderColor = UIColor(red: 13/255, green: 9/255, blue: 37/255, alpha: 0.4)
    private static let defaultPlaceholderFontSize: CGFloat = 15
    private static let defaultPlaceholderFont = UIFont(name: "SFUIText-Light", size: defaultPlaceholderFontSize)
    private let placeholderLabel: UILabel = UILabel()
    private var placeholderCenterYConstraint = NSLayoutConstraint()

    @IBInspectable var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }

    @IBInspectable var placeholderColor: UIColor = DesignableDynamicTextView.defaultPlaceholderColor {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }

    @IBInspectable var placeholderFontSize: CGFloat = DesignableDynamicTextView.defaultPlaceholderFontSize {
        didSet {
            placeholderLabel.font = placeholderLabel.font.withSize(placeholderFontSize)
        }
    }

    var placeholderFont: UIFont? = DesignableDynamicTextView.defaultPlaceholderFont {
        didSet {
            let font = (placeholderFont != nil) ? placeholderFont : self.font
            placeholderLabel.font = font
        }
    }

    override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    override var text: String! {
        didSet {
            textDidChange()
        }
    }

    override var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }

    override var textContainerInset: UIEdgeInsets {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }

    // MARK: - Corners

    @IBInspectable var cornerRadius: CGFloat = .nan {
        didSet {
            setupCorners()
        }
    }
    
    @IBInspectable var isCircular: Bool = false {
        didSet {
            setupCorners()
        }
    }

    @IBInspectable var cornerRadiusFraction: CGFloat = .nan {
        didSet {
            setupCorners()
        }
    }

    // MARK: - Border

    @IBInspectable var borderWidth: CGFloat = CGFloat.nan {
        didSet {
            setupBorder()
        }
    }

    @IBInspectable var borderColor: UIColor? = nil {
        didSet {
            setupBorder()
        }
    }

    // MARK: - Initializers

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: .UITextViewTextDidChange,
                                               object: nil)
        placeholderLabel.font = placeholderFont
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 1
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        setupConstraintsForPlaceholderLabel()
        textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
    }

    // MARK: - Private methods

    private func setupConstraintsForPlaceholderLabel() {
        let leadingConstant = textContainerInset.left + textContainer.lineFragmentPadding
        let leadingConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                                          constant: leadingConstant)
        let widthConstant = -(textContainerInset.left + textContainerInset.right + textContainer.lineFragmentPadding * 2.0)
        let widthConstraint = placeholderLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: widthConstant)
        placeholderCenterYConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        NSLayoutConstraint.activate([leadingConstraint, widthConstraint, placeholderCenterYConstraint])
    }

    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCorners()
        setupBorder()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2.0
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
        topCorrection = max(0, topCorrection)
        placeholderCenterYConstraint.constant = -topCorrection
    }
}
