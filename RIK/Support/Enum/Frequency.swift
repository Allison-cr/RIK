//
//  Frequency.swift
//  RIK
//
//  Created by Alexander Suprun on 22.09.2024.
//

import Foundation

enum Frequency {
    case day, week, month, alltime
    
    func toLineGraphString() -> String {
        switch self {
        case .day:
            return "По дням"
        case .week:
            return "По неделям"
        case .month:
            return "По Месяцам"
        case .alltime:
            return "За все время"
        }
    }
    
    func toPieGhaphString() -> String {
        switch self {
        case .day:
            return "Сегодня"
        case .week:
            return "Неделя"
        case .month:
            return "Месяц"
        case .alltime:
            return "За все время"
        }
    }
}
