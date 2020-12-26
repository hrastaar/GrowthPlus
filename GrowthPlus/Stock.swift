//
//  Stock.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

struct Stock: Hashable {
    // info to gather from Realm
    let companyName: String
    let ticker: String
    var avgCost: Double
    var shares: Int
    // info to gather from API
    var currentPrice: Double
    var percentChange: Double
    var dailyChange: Double

    var volume: Int
    var avgVolume: Int

    // Calculations from data observed
    func calculateEquity() -> Double {
        return Double(shares) * currentPrice
    }

    func calculateTotalCost() -> Double {
        return Double(shares) * avgCost
    }

    func calculateNetProfit() -> Double {
        return calculateEquity() - calculateTotalCost()
    }

    var dailySign: String {
        percentChange >= 0 ? "+" : "-"
    }

    var totalSign: String {
        currentPrice >= avgCost ? "+" : "-"
    }

    // UI elements
    let imageName: String
    var isSelected = false
    var backgroundColor: Color {
        isSelected ? CustomColors.shared.primaryColor : CustomColors.shared.secondaryColor
    }

    var textColor: Color {
        .white
    }
}
