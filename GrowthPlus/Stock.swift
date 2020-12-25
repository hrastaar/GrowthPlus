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

class StockPageData: ObservableObject {
    let companyName: String
    let ticker: String
    // info to gather from API
    var currentPrice: Double
    var percentChange: Double
    var dailyChange: Double

    var volume: Int
    var avgVolume: Int

    var open: Double
    var low: Double
    var high: Double
    var yearLow: Double
    var yearHigh: Double

    var primaryExchange: String
    var marketCap: Int
    var peRatio: Double

    init(companyName: String, ticker: String, currentPrice: Double, percentChange: Double, dailyChange: Double, volume: Int, avgVolume: Int, open: Double, low: Double, high: Double, yearLow: Double, yearHigh: Double, primaryExchange: String, marketCap: Int, peRatio: Double) {
        self.companyName = companyName
        self.ticker = ticker
        self.currentPrice = currentPrice
        self.percentChange = percentChange
        self.dailyChange = dailyChange
        self.volume = volume
        self.avgVolume = avgVolume
        self.open = open
        self.low = low
        self.high = high
        self.yearLow = yearLow
        self.yearHigh = yearHigh
        self.primaryExchange = primaryExchange
        self.marketCap = marketCap
        self.peRatio = peRatio
    }

    init() {
        companyName = "NA"
        ticker = "NA"
        currentPrice = 0.00
        percentChange = 0.00
        dailyChange = 0.00
        volume = 0
        avgVolume = 0
        open = 0.00
        low = 0.00
        high = 0.00
        yearLow = 0.00
        yearHigh = 0.00
        primaryExchange = "NA"
        marketCap = 0
        peRatio = 0.00
    }
}
