//
//  StockPageData.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/25/20.
//

import Foundation

class StockDetailData: ObservableObject, Codable {
    @Published var successfulLoad: Bool = false
    var companyName: String = "Not Available"
    var ticker: String = ""
    // info to gather from API
    var currentPrice: Double = 0.00
    var percentChange: Double = 0.00
    var dailyChange: Double = 0.00
    var latestTime: String = "Latest Time Default Value"
    var volume: Int = 0
    var avgVolume: Int = 0

    var open: Double = 0.00
    var low: Double? = 0.00
    var high: Double? = 0.00
    var yearLow: Double = 0.00
    var yearHigh: Double = 0.00

    var primaryExchange: String = ""
    var marketCap: Int = 0
    var peRatio: Double = 0.00
    
    required init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.companyName = try container.decode(String.self, forKey: .companyName)
            self.ticker = try container.decode(String.self, forKey: .ticker)
            self.currentPrice = try container.decode(Double.self, forKey: .currentPrice)
            self.percentChange = try container.decodeIfPresent(Double.self, forKey: .percentChange) ?? 0.0
            self.dailyChange = try container.decodeIfPresent(Double.self, forKey: .dailyChange) ?? 0.0
            self.latestTime = try container.decode(String.self, forKey: .latestTime)
            self.volume = try container.decodeIfPresent(Int.self, forKey: .volume) ?? 0
            self.avgVolume = try container.decodeIfPresent(Int.self, forKey: .volume) ?? 0
            
            self.open = try container.decodeIfPresent(Double.self, forKey: .open) ?? 0.00
            self.low = try container.decodeIfPresent(Double.self, forKey: .low) ?? 0.00
            self.high = try container.decodeIfPresent(Double.self, forKey: .high) ?? 0.00
            self.yearLow = try container.decodeIfPresent(Double.self, forKey: .yearLow) ?? 0.00
            self.yearHigh = try container.decodeIfPresent(Double.self, forKey: .yearHigh) ?? 0.00
            
            self.primaryExchange = try container.decodeIfPresent(String.self, forKey: .primaryExchange) ?? "N/A"
            self.marketCap = try container.decodeIfPresent(Int.self, forKey: .marketCap) ?? 0
            self.peRatio = try container.decodeIfPresent(Double.self, forKey: .peRatio) ?? 0.00
            
            self.checkForValidity()
            self.truncateExchangeName()
        } catch {
            print(error.localizedDescription)
        }

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
        
        self.truncateExchangeName()
        self.checkForValidity()
    }

    init() {
        companyName = ""
        ticker = "NA"
        latestTime = "December 24, 2020"
        primaryExchange = "NA"
        
        self.truncateExchangeName()
        self.checkForValidity()
    }

    enum CodingKeys: String, CodingKey {
        case companyName
        case ticker = "symbol"
        // Intraday Info
        case currentPrice = "latestPrice"
        case percentChange = "changePercent"
        case dailyChange = "change"
        case volume
        case avgVolume = "avgTotalVolume"
        case latestTime
        // Record Price Data
        case open
        case low
        case high
        case yearLow = "week52Low"
        case yearHigh = "week52High"
        // Market Cap Data
        case primaryExchange
        case marketCap
        case peRatio
    }

    private func truncateExchangeName() {
        if primaryExchange == "NEW YORK STOCK EXCHANGE, INC." {
            primaryExchange = "NYSE"
            return
        }
        var shortenedExchange = ""
        for char in primaryExchange {
            if char == "/" || char == "(" {
                break
            }
            shortenedExchange.append(char)
        }
        primaryExchange = shortenedExchange
    }

    private func checkForValidity() {
        successfulLoad = companyName != "Not Available" && currentPrice != 0.00
    }
}
