//
//  GenderView.swift
//  RIK
//
//  Created by Alexander Suprun on 20.09.2024.
//

import UIKit
import PinLayout

final class GenderView: UIView {
    
    private var gender: Gender
    
    private lazy var genderLabel: UILabel = {
        let label = UILabel()
        label.text = gender.getTittle()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = gender.getColor()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(gender: Gender) {
        self.gender = gender
        super.init(frame: .zero)
        addSubview(genderImage)
        addSubview(genderLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = genderLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        let width = 16 + 8 + labelSize.width
        let height = max(16, labelSize.height)
        return CGSize(width: width + 16, height: height + 16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.translatesAutoresizingMaskIntoConstraints = false
        genderImage.pin
            .left(16)
            .vCenter()
            .size(12)
        
        genderLabel.pin
            .after(of: genderImage, aligned: .center).marginLeft(6)
            .height(16)
        
        layer.cornerRadius = 16
    }
}
