//
//  CustomXAxisValueFormatter.swift
//  RIK
//
//  Created by Alexander Suprun on 20.09.2024.
//

import DGCharts

class CustomXAxisValueFormatter: AxisValueFormatter {
    private let xValues: [Double]
    
    init(values: [Double]) {
        self.xValues = values
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let closest = xValues.min(by: { abs($0 - value) < abs($1 - value) }) {
            return String(format: "%.2f", closest)
        }
        return ""
    }
}
