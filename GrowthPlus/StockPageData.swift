//
//  StockPageData.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/25/20.
//

import Foundation

class StockPageData: ObservableObject, Codable {
    let companyName: String
    let ticker: String
    // info to gather from API
    var currentPrice: Double
    var percentChange: Double
    var dailyChange: Double
    var latestTime: String

    var volume: Int
    var avgVolume: Int

    var open: Double
    var low: Double
    var high: Double
    var yearLow: Double
    var yearHigh: Double

    var primaryExchange: String
    var marketCap: Int
    var peRatio: Double = 0.00
    var success: Bool? {
        companyName != "NA" && currentPrice != 0.00
    }
    
    init(companyName: String, ticker: String, currentPrice: Double, percentChange: Double, dailyChange: Double, volume: Int, avgVolume: Int, latestTime: String, open: Double, low: Double, high: Double, yearLow: Double, yearHigh: Double, primaryExchange: String, marketCap: Int, peRatio: Double) {
        self.companyName = companyName
        self.ticker = ticker
        self.currentPrice = currentPrice
        self.percentChange = percentChange
        self.dailyChange = dailyChange
        self.latestTime = latestTime
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
        latestTime = "December 24, 2020"
        open = 0.00
        low = 0.00
        high = 0.00
        yearLow = 0.00
        yearHigh = 0.00
        primaryExchange = "NA"
        marketCap = 0
        peRatio = 0.00
    }
    
    enum CodingKeys: String, CodingKey {
        case companyName = "companyName"
        case ticker = "symbol"
        // Intraday Info
        case currentPrice = "latestPrice"
        case percentChange = "changePercent"
        case dailyChange = "change"
        case volume = "volume"
        case avgVolume = "avgTotalVolume"
        case latestTime = "latestTime"
        // Record Price Data
        case open = "open"
        case low = "low"
        case high = "high"
        case yearLow = "week52Low"
        case yearHigh = "week52High"
        // Market Cap Data
        case primaryExchange = "primaryExchange"
        case marketCap = "marketCap"
        case peRatio = "peRatio"
    }
    
    func truncateExchangeName() {
        if self.primaryExchange == "NEW YORK STOCK EXCHANGE, INC." {
            self.primaryExchange = "NYSE"
            return
        }
        var shortenedExchange = ""
        for char in self.primaryExchange {
            if char == "/" || char == "(" {
                break
            }
            shortenedExchange.append(char)
        }
        self.primaryExchange = shortenedExchange
    }
}
