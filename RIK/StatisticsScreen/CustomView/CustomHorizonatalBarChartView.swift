//
//  CustomHorizonatalBarChartView.swift
//  RIK
//
//  Created by Alexander Suprun on 20.09.2024.
//
import Foundation
import UIKit
import PinLayout

final class CustomHorizontalBarChartView: UIView {
    
    private let ageGroup: String
    private let menPercentage: Int
    private let womenPercentage: Int
    
    private lazy var ageLabel: UILabel = {
        let label = UILabel()
        label.text = ageGroup
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var percentWImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .women
        imageView.layer.cornerRadius = 2.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var percentMImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .man
        imageView.layer.cornerRadius = 2.5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var percentMTextLabel: UILabel = {
        let label = UILabel()
        label.text = "\(menPercentage)%"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var percentWTextLabel: UILabel = {
        let label = UILabel()
        label.text = "\(womenPercentage)%"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    init(ageGroup: String, menPercentage: Int, womenPercentage: Int) {
        self.ageGroup = ageGroup
        self.menPercentage = menPercentage
        self.womenPercentage = womenPercentage
        super.init(frame: .zero)
        addSubview(ageLabel)
        addSubview(percentMImageView)
        addSubview(percentWImageView)
        addSubview(percentMTextLabel)
        addSubview(percentWTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        
        ageLabel.pin
            .left(16)
            .top()
            .width(64)
            .height(16)
        
        let totalAvailableWidth = UIScreen.main.bounds.width - ageLabel.frame.width - 32
        percentMImageView.pin
            .topLeft(to: ageLabel.anchor.topRight)
            .width(CGFloat(menPercentage) / 100 * totalAvailableWidth == 0 ? 5 : CGFloat(menPercentage) / 100 * totalAvailableWidth)
            .height(5)
        
        percentMTextLabel.pin
            .centerLeft(to: percentMImageView.anchor.centerRight).marginLeft(10)
        
        percentWImageView.pin
            .below(of: percentMImageView).marginTop(6)
            .bottomLeft(to: ageLabel.anchor.bottomRight)
            .width(CGFloat(womenPercentage) / 100 * totalAvailableWidth == 0 ? 5 : CGFloat(womenPercentage) / 100 * totalAvailableWidth)
            .height(5)
        
        percentWTextLabel.pin
            .centerLeft(to: percentWImageView.anchor.centerRight).marginLeft(10)
    }
}
