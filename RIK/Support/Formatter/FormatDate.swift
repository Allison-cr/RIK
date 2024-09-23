//
//  formatDate.swift
//  RIK
//
//  Created by Alexander Suprun on 19.09.2024.
//

import Foundation

func formatDateToDouble(from number: Int) -> Double? {
    let numberString = String(number)
    
    // Убедитесь, что число имеет хотя бы 6 цифр
    guard numberString.count >= 6 else {
        return nil
    }
    
    // Разделите число на месяц и день
    let monthString = numberString.dropLast(4).suffix(2) // MM
    let dayString = numberString.dropLast(6) // DD

    // Преобразуйте в целые числа
    guard let month = Int(monthString), let day = Int(dayString) else {
        return nil
    }
    
    // Форматирование и преобразование в Double
    let formattedValue = Double(day) + Double(month) / 100
    return formattedValue
}
