//
//  CryptocurrencyData.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/13/21.
//

import Foundation

class CryptocurrencyData: ObservableObject {
    var ticker: String
    var price: String
    var date: String

    init(ticker: String, price: String, date: Int) {
        self.ticker = ticker
        let priceDouble = Double(price) ?? 0
        self.price = String(format: "$%.2f", priceDouble)
        let timeInterval = TimeInterval(date) / 1000
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "EST")
        formatter.dateFormat = "HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeInterval)
        self.date = "Last Updated: " + formatter.string(from: date) + " EST"
    }
}
