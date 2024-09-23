//
//  CustomTableViewCell.swift
//  RIK
//
//  Created by Alexander Suprun on 20.09.2024.
//

import UIKit
import PinLayout

class UserCell: UITableViewCell {
    
    private lazy var userNameLabel: UILabel = setupUserName()
    private lazy var photoImageView: UIImageView = setupImageView()
    private lazy var ageLabel: UILabel = setupAgeLabel()
    private lazy var goProfileButton: UIButton = setupGoProfileButton()
    private lazy var onlineImageView: UIImageView = setupOnlineImageView()
    private lazy var onlineBackImageView: UIImageView = setupBackOnlineImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(ageLabel)
        contentView.addSubview(goProfileButton)
        contentView.addSubview(onlineBackImageView)
        contentView.addSubview(onlineImageView)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: Users) {
        userNameLabel.text = " \(model.username), \(model.age)"
       
        
        if let file = model.files.first, let url = URL(string: file.url) {
            photoImageView.loadImage(from: url)
               }
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
        
        photoImageView.pin
                .vertically(12)
                .left(16)
                .size(38)
        
        onlineBackImageView.pin
            .bottomRight(to : photoImageView.anchor.bottomRight)
            .size(9)
        
        onlineImageView.pin
            .bottomRight(to : photoImageView.anchor.bottomRight)
            .size(8)
        
        
        userNameLabel.pin
            .after(of: photoImageView).marginLeft(12)
            .sizeToFit()
            .vCenter()
        
        ageLabel.pin
            .after(of: userNameLabel).marginLeft(12)
            .top(8)
        
        goProfileButton.pin
            .right(24)
            .size(16)
            .vCenter()
        }
}

private extension UserCell {
    
    func setupUserName() -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        return label
    }
    
    func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }
    
    func setupAgeLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .black
        return label
    }
    
    func setupGoProfileButton() -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .nextButton
        return button
    }
    
    func setupOnlineImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .green
        return imageView
    }
    
    func setupBackOnlineImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = .white
        return imageView
    }
    
}
