//
//  StockListData.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 1/2/21.
//

import Foundation

struct StockListData: Decodable {
    var ticker: String = "N/A"
    var companyName: String = "N/A"
    var percentChange: Double = 0.00
    var dailyChange: Double = 0.00

    var displayPercentChange: String {
        String(format: "%.2f%%", percentChange * 100.00)
    }

    var description: String {
        let val = ("Ticker: " + ticker + ", company: " + companyName + ", change percent: " + displayPercentChange + ", daily change: " + String(dailyChange))
        return val
    }

    enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
        case companyName
        case percentChange = "changePercent"
        case dailyChange = "change"
    }
}
