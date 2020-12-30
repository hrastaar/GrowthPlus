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
    @Published var portfolioCards: [Stock] = []
    // Calculated Balances
    @Published var realizedGains: Double = 0.00
    @Published var unrealizedGains: Double = 0.00
    @Published var totalStockValue: Double = 0.00

    @Published var loadedHoldings: Bool = false
    @Published var firstVisit: Bool = false
    @State var presentStocks: Bool = true

    // Personal account info provided by realm
    var portfolio: RealmPortfolio?

    var selectedCard: Stock {
        portfolioCards.first(where: { $0.isSelected }) ?? emptyStock
    }

    static var shared = Portfolio()
    let realm: Realm

    init() {
        let realmConfigurations: Realm.Configuration = try! Realm().configuration
        realm = try! Realm(configuration: realmConfigurations)
        let fetchedPortfolio: [RealmPortfolio] = Array(realm.objects(RealmPortfolio.self))
        // if no portfolio element found
        if fetchedPortfolio.isEmpty {
            firstVisit = true
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
        var stock: Stock?
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
                    stock = Stock(companyName: companyName, ticker: holding.ticker, avgCost: holding.avgCost, shares: holding.shares, currentPrice: currPrice, percentChange: percentChange, dailyChange: dailyChange, volume: volume, avgVolume: avgVolume, imageName: "stock")
                    if self.portfolioCards.count == 0 {
                        stock?.isSelected = true
                    }
                    self.portfolioCards.append(stock!)
                    self.totalStockValue += stock!.calculateEquity()
                    self.loadedHoldings = true
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
        // Update balance to the new balance
        realizedGains += ((salePrice - avgPrice) * Double(shares))
        totalStockValue -= (salePrice * Double(shares))
        try! realm.write {
            self.portfolio!.overallBalance = realizedGains
        }

        for index in 0 ..< portfolio!.holdings.count {
            if portfolio!.holdings[index].ticker == ticker {
                print("Sell for ticker: \(ticker), trying to sell \(shares) shares. There are currently: \(portfolio!.holdings[index].shares)")
                try! realm.write {
                    portfolio!.holdings[index].shares -= shares
                    portfolioCards[index].shares -= shares
                    if portfolio!.holdings[index].shares == 0 {
                        realm.delete(portfolio!.holdings[index])
                        for i in 0 ..< portfolioCards.count {
                            if portfolioCards[i].ticker == ticker {
                                // if applicable set the selected card to the next one
                                if i == 0, portfolioCards.count > 1 {
                                    portfolioCards[i + 1].isSelected = true
                                } else if i > 0, portfolioCards.count > 1 {
                                    portfolioCards[0].isSelected = true
                                }
                                portfolioCards.remove(at: i)
                                if portfolioCards.count == 0 {
                                    self.presentStocks = false
                                }
                                break
                            }
                        }
                    }
                }
                calculateUnrealizedGains()
                return
            }
        }
    }

    func buyShare(ticker: String, shares: Int, salePrice: Double) {
        // iterate thru cards to see if ticker already in portfolio
        for index in 0 ..< portfolio!.holdings.count {
            if portfolio!.holdings[index].ticker == ticker {
                try! realm.write {
                    portfolio!.holdings[index].avgCost = (portfolioCards[index].calculateEquity() + (salePrice * Double(shares))) / Double(portfolioCards[index].shares + shares)
                    portfolio!.holdings[index].shares = portfolioCards[index].shares + shares
                }
                portfolioCards[index].avgCost = (portfolioCards[index].calculateEquity() + (salePrice * Double(shares))) / Double(portfolioCards[index].shares + shares)
                portfolioCards[index].shares = portfolioCards[index].shares + shares
                calculateUnrealizedGains()
                totalStockValue += (Double(shares) * salePrice)
                return
            }
        }

        // If here, write new stock
        let realmStockData = RealmStockData()
        realmStockData.ticker = ticker
        realmStockData.avgCost = salePrice
        realmStockData.shares = shares
        try! realm.write {
            portfolio!.holdings.append(realmStockData)
            self.appendStockData(holding: realmStockData)
        }
        calculateUnrealizedGains()
    }

    private var emptyStock: Stock {
        Stock(companyName: "", ticker: "", avgCost: 0.0, shares: 0, currentPrice: 0.0, percentChange: 0.0, dailyChange: 0.0, volume: 0, avgVolume: 0, imageName: "")
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
        return success
    }
}
