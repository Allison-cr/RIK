//
//  TypeData.swift
//  RIK
//
//  Created by Alexander Suprun on 23.09.2024.
//

import Foundation

enum TypeData {
    case view
    case subscription
    case unsubscription
    
    func getMessage() -> String {
        switch self {
        case .view:
            return "view"
        case .subscription:
            return "subscription"
        case .unsubscription:
            return "unsubscription"
        }
    }
}
