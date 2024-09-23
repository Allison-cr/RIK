//
//  ViewsEnum.swift
//  RIK
//
//  Created by Alexander Suprun on 22.09.2024.
//

import Foundation
import UIKit

enum Views {
    case up
    case down
    
    func getTittle() -> String {
        switch self {
        case .up:
            return "Новые наблюдатели в этом месяце"
        case .down:
            return "Пользователей отписались от Вас"
        }
    }
    
    func getImage() -> UIImage {
        switch self {
        case .up:
            return UIImage(resource: .up)
        case .down:
            return UIImage(resource: .down)
        }
    }
    
    func getShadowImage() -> UIImage {
        switch self {
        case .up:
            return UIImage(resource: .shadowUp)
        case .down:
            return UIImage(resource: .shadowDown)
        }
    }
    
    func getVector() -> UIImage {
        switch self {
        case .up:
            return UIImage(resource: .upVector)
        case .down:
            return UIImage(resource: .downVector)
        }
    }
}
