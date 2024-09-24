//
//  SignView.swift
//  RIK
//
//  Created by Alexander Suprun on 19.09.2024.
//


import UIKit
import PinLayout

final class SignView: UIView {
    
    var state: Views
    
    var quantity: Int {
        didSet {
            updateQuantityLabel()
        }
    }
    
    init(state: Views, quantity: Int) {
        self.state = state
        self.quantity = quantity
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: state.getShadowImage())
        imageView.tintColor = .label
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var imageSecondView: UIImageView = {
        let imageView = UIImageView(image: state.getImage())
        imageView.tintColor = .label
        addSubview(imageView)
        return imageView
    }()
    
    private lazy var label1: UILabel = {
        let label = UILabel()
        let attributedString = NSMutableAttributedString()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "Vector")
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        let imageString = NSAttributedString(attachment: imageAttachment)
        let text = NSAttributedString(string: "\(quantity)",
                                      attributes: [
                                        .font: UIFont.systemFont(ofSize: 20, weight: .medium),
                                        .foregroundColor: UIColor.black
                                      ])
        attributedString.append(text)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(imageString)
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()
    
    private lazy var label2: UILabel = {
        let label = UILabel()
        label.text = state.getTittle()
        label.textColor = .subscriptText
        label.font = UIFont(name: "Gilroy", size: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()
    
    override var intrinsicContentSize: CGSize {
        let width = UIScreen.main.bounds.width - 32
        let height = CGFloat(98)
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
 
    private func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 16
        imageView.pin
            .top(32)
            .left(16)
            .sizeToFit()
        
        imageSecondView.pin
            .top(25)
            .left(16)
            .sizeToFit()

        
        label1.pin
            .top(16)
            .after(of: imageView).marginLeft(20)
            .right(16)
            .sizeToFit()

        label2.pin
            .below(of: label1).marginTop(7)
            .after(of: imageView).marginLeft(20)
            .right(16)
            .sizeToFit(.width)
        self.invalidateIntrinsicContentSize()
    }
    
    
    private func updateQuantityLabel() {
        let attributedString = NSMutableAttributedString()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: "Vector")
        imageAttachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
        let imageString = NSAttributedString(attachment: imageAttachment)
        let text = NSAttributedString(string: "\(quantity)",
                                      attributes: [
                                        .font: UIFont.systemFont(ofSize: 20, weight: .medium),
                                        .foregroundColor: UIColor.black
                                      ])
        attributedString.append(text)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(imageString)
        label1.attributedText = attributedString
    }
}
