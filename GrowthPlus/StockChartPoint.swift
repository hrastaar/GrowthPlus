//
//  StockChartPoint.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/25/20.
//

import Foundation

struct StockChartPoint: Codable {
    let timeLabel: String
    let avgPrice: Double
    let highPrice: Double
    let lowPrice: Double

    enum CodingKeys: String, CodingKey {
        case timeLabel = "label"
        case avgPrice = "average"
        case highPrice = "high"
        case lowPrice = "low"
    }
}
