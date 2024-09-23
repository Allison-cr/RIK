//
//  GenderEnum.swift
//  RIK
//
//  Created by Alexander Suprun on 20.09.2024.
//

import UIKit

enum Gender {
    case man
    case woman
    
    func getTittle() -> String {
        switch self {
        case .man:
            return "Мужчины"
        case .woman:
            return "Женщины"
        }
    }
    
    func getColor() -> UIColor {
        switch self {
        case .man:
            return .man
        case .woman:
            return .women
        }
    }
}
