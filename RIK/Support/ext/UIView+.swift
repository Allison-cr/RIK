//
//  UIView+.swift
//  RIK
//
//  Created by Alexander Suprun on 20.09.2024.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        self.image = nil
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data")
                    return
                }
                
                self.image = image
            }
        }
        task.resume()
    }
}

extension UIImageView {
    func separator() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = .border
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
