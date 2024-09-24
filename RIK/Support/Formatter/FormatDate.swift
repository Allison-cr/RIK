//
//  formatDate.swift
//  RIK
//
//  Created by Alexander Suprun on 19.09.2024.
//

import Foundation

func formatDateToDouble(from number: Int) -> Double? {
    let numberString = String(number)
    
    guard numberString.count >= 6 else {
        return nil
    }
    
    let monthString = numberString.dropLast(4).suffix(2)
    let dayString = numberString.dropLast(6) 

    guard let month = Int(monthString), let day = Int(dayString) else {
        return nil
    }
    
    let formattedValue = Double(day) + Double(month) / 100
    return formattedValue
}
