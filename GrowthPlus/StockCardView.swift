//
//  Stock.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/12/20.
//

import SwiftUI

class StockDataModel: ObservableObject, Equatable {
    @ObservedObject var colorManager = CustomColors.shared

    static func == (lhs: StockDataModel, rhs: StockDataModel) -> Bool {
        return lhs.ticker == rhs.ticker
    }
    
    required init(companyName: String, ticker: String, avgCost: Double, shares: Int, currentPrice: Double, percentChange: Double, dailyChange: Double, volume: Int, avgVolume: Int, imageName: String) {
        self.companyName = companyName
        self.ticker = ticker
        self.avgCost = avgCost
        self.shares = shares
        self.currentPrice = currentPrice
        self.percentChange = percentChange
        self.dailyChange = dailyChange
        self.volume = volume
        self.avgVolume = avgVolume
        self.imageName = imageName
    }
    // info to gather from Realm
    let companyName: String
    let ticker: String
    @Published var avgCost: Double
    @Published var shares: Int
    // info to gather from API
    @Published var currentPrice: Double
    @Published var percentChange: Double
    @Published var dailyChange: Double

    @Published var volume: Int
    @Published var avgVolume: Int

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
    @Published var isSelected = false
    var backgroundColor: Color {
        isSelected ? colorManager.primaryColor : colorManager.secondaryColor
    }

    var textColor: Color {
        isSelected ? colorManager.getPrimaryBackgroundTextColor() : colorManager.getSecondaryBackgroundTextColor()
    }
}
