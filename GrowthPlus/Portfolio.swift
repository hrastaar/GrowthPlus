//
//  Portfolio.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/13/20.
//

import Alamofire
import RealmSwift
import SwiftUI
import SwiftyJSON

final class Portfolio: ObservableObject {
    // Data for portfolio stocks
    @Published var portfolioCards: [StockDataModel] = []
    // Calculated Balances
    @Published var realizedGains: Double = 0.00
    @Published var unrealizedGains: Double = 0.00
    @Published var totalStockValue: Double = 0.00

    // Personal account info provided by realm
    var portfolio: RealmPortfolio?

    @Published var selectedCard: StockDataModel?

    static var shared = Portfolio()
    
    let realm: Realm

    init() {
        let realmConfigurations: Realm.Configuration = try! Realm().configuration
        realm = try! Realm(configuration: realmConfigurations)
        let fetchedPortfolio: [RealmPortfolio] = Array(realm.objects(RealmPortfolio.self))
        // if no portfolio element found
        if fetchedPortfolio.isEmpty {
            // initialize a new object
            portfolio = RealmPortfolio()
            try! realm.write {
                realm.add(self.portfolio!)
            }
            initializeWithSavedHoldings(realmStockHoldings: Array(portfolio!.holdings))
        } else {
            portfolio = fetchedPortfolio[0]
            let realmSavedStocks = Array(portfolio!.holdings)
            realizedGains = fetchedPortfolio[0].overallBalance
            initializeWithSavedHoldings(realmStockHoldings: realmSavedStocks)
        }
    }

    private func initializeWithSavedHoldings(realmStockHoldings: [RealmStockData]) {
        for holding in realmStockHoldings {
            appendStockData(holding: holding)
        }
    }

    private func appendStockData(holding: RealmStockData) {
        var stock: StockDataModel?
        // build get request
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(holding.ticker)/quote?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let request = AF.request(url)
        request.responseJSON { data in
            do {
                if let currData = data.data {
                    let json: JSON = try JSON(data: currData)
                    // if valid call and has the info we need, create StockData type
                    let companyName: String = json["companyName"].stringValue
                    let volume: Int = json["volume"].intValue
                    let avgVolume: Int = json["avgTotalVolume"].intValue
                    let currPrice: Double = json["latestPrice"].doubleValue
                    let percentChange: Double = json["changePercent"].doubleValue
                    let dailyChange: Double = json["change"].doubleValue
                    stock = StockDataModel(companyName: companyName, ticker: holding.ticker, avgCost: holding.avgCost, shares: holding.shares, currentPrice: currPrice, percentChange: percentChange, dailyChange: dailyChange, volume: volume, avgVolume: avgVolume, imageName: "stock")
                    if self.portfolioCards.count == 0 {
                        stock?.isSelected = true
                    }
                    self.portfolioCards.append(stock!)
                    print("added stock with ticker: \(stock!.ticker). Size is now: \(self.portfolioCards.count)")
                    self.selectedCard = self.portfolioCards.first(where: { $0.isSelected })
                    self.totalStockValue += stock!.calculateEquity()
                    self.calculateUnrealizedGains()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func calculateUnrealizedGains() {
        var unrealizedGain: Double = 0.00
        for card in portfolioCards {
            unrealizedGain += (Double(card.shares) * (card.currentPrice - card.avgCost))
        }
        unrealizedGains = unrealizedGain
    }

    func sellShare(ticker: String, shares: Int, salePrice: Double, avgPrice: Double) {
        
        if let currentHolding = portfolio?.holdings.first(where: { $0.ticker == ticker }),
           let portfolioCard = portfolioCards.first(where: { $0.ticker == ticker }),
           let idx = portfolioCards.firstIndex(where: {$0.ticker == ticker }){
            if currentHolding.shares < shares {
                print("Error occurred. portfolio holding shares was less than what is sold")
                return
            }
            print("Sell for ticker: \(ticker), trying to sell \(shares) shares. There are currently: \(currentHolding.shares)")
            // Update balance to the new balance
            realizedGains += ((salePrice - avgPrice) * Double(shares))
            totalStockValue -= (salePrice * Double(shares))
            try! realm.write {
                self.portfolio!.overallBalance = realizedGains
                currentHolding.shares -= shares
                portfolioCard.shares -= shares
                if currentHolding.shares == 0 {
                    realm.delete(currentHolding)
                    if(portfolioCards.count > 1) {
                        if(idx == 0) {
                            portfolioCards[idx + 1].isSelected = true
                            selectedCard = portfolioCards[idx + 1]
                        } else {
                            portfolioCards[0].isSelected = true
                            selectedCard = portfolioCards[0]
                        }
                    }
                    portfolioCards.remove(at: idx);
                    if portfolioCards.isEmpty {
                        self.selectedCard = nil
                    }
                }
            }
            calculateUnrealizedGains()
            return
        }
    }

    func buyShare(ticker: String, shares: Int, salePrice: Double) {
        if let currentHolding = portfolio!.holdings.first(where: {$0.ticker == ticker}),
           let portfolioCard = portfolioCards.first(where: {$0.ticker == ticker}) {
            try! realm.write {
                currentHolding.avgCost = (portfolioCard.calculateEquity() + (salePrice * Double(shares))) / Double(portfolioCard.shares + shares)
                currentHolding.shares = portfolioCard.shares + shares
            }
            portfolioCard.avgCost = (portfolioCard.calculateEquity() + (salePrice * Double(shares))) / Double(portfolioCard.shares + shares)
            portfolioCard.shares = portfolioCard.shares + shares
            calculateUnrealizedGains()
            totalStockValue += (Double(shares) * salePrice)
            return
        } else {
            // If here, write new stock
            let realmStockData = RealmStockData()
            realmStockData.ticker = ticker
            realmStockData.avgCost = salePrice
            realmStockData.shares = shares
            try! realm.write {
                portfolio!.holdings.append(realmStockData)
                self.appendStockData(holding: realmStockData)
            }
            self.selectedCard = self.portfolioCards.first(where: { $0.isSelected })
            calculateUnrealizedGains()
        }
    }

    // Resets Realm Portfolio. Returns true if successful reset
    func resetPortfolio() -> Bool {
        var success: Bool = false
        try! realm.write {
            if let portfolio = self.portfolio {
                realm.delete(portfolio)
                self.portfolioCards.removeAll()
                self.portfolio = RealmPortfolio()
                success = true
            }
        }
        self.selectedCard = self.portfolioCards.first(where: { $0.isSelected })
        return success
    }
}
