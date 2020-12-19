//
//  Portfolio.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/13/20.
//

import Alamofire
import RealmSwift
import SwiftyJSON
import SwiftUI

final class Portfolio: ObservableObject {
    @Published var portfolioCards: [Stock] = []
    @Published var realizedGains: Double = 0.00
    @Published var unrealizedGains: Double = 0.00
    @Published var loadedHoldings = false
    @Published var totalStockValue = 0.00
    @State var presentStocks = true

    var portfolio: RealmPortfolio?
    var selectedCard: Stock {
        portfolioCards.first(where: { $0.isSelected }) ?? emptyStock
    }
    static var shared: Portfolio = Portfolio()
    
    init() {
        let realmConfigurations = try! Realm().configuration
        let realm = try! Realm(configuration: realmConfigurations)
        let portfolio = Array(realm.objects(RealmPortfolio.self))
        // if no portfolio element found
        if portfolio.isEmpty {
            // initialize a new object
            self.portfolio = RealmPortfolio()
            try! realm.write {
                realm.add(self.portfolio!)
            }
            self.initializeWithSavedHoldings(stockHoldings: Array(self.portfolio!.holdings))
        } else {
            self.portfolio = portfolio[0]
            let stocks = Array(self.portfolio!.holdings)
            self.realizedGains = portfolio[0].overallBalance
            self.initializeWithSavedHoldings(stockHoldings: stocks)
        }
    }
    
    private func initializeWithSavedHoldings(stockHoldings: [RealmStockData]) {
        for holding in stockHoldings {
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
                    let json = try JSON(data: currData)
                    // if valid call and has the info we need, create StockData type
                    let companyName = json["companyName"].stringValue
                    let volume = json["volume"].intValue
                    let avgVolume = json["avgTotalVolume"].intValue
                    let currPrice = json["latestPrice"].doubleValue
                    let percentChange = json["changePercent"].doubleValue
                    let dailyChange = json["change"].doubleValue
                    stock = Stock(companyName: companyName, ticker: holding.ticker, avgCost: holding.avgCost, shares: holding.shares, currentPrice: currPrice, percentChange: percentChange, dailyChange: dailyChange, volume: volume, avgVolume: avgVolume, imageName: "stock")
                    if self.portfolioCards.count == 0 {
                        stock?.isSelected = true
                    }
                    self.portfolioCards.append(stock!)
                    self.totalStockValue += stock!.equity
                    self.loadedHoldings = true
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func calculateUnrealizedGains() -> Double {
        var realizedGain = 0.00
        for card in portfolioCards {
            realizedGain += card.netProfit
        }
        return realizedGain
    }
    
    func sellShare(ticker: String, shares: Int, salePrice: Double, avgPrice: Double) {
        let realm = try! Realm()
        // Update balance to the new balance
        self.realizedGains += ((salePrice - avgPrice) * Double(shares))
        self.totalStockValue -= (salePrice * Double(shares))
        try! realm.write {
            self.portfolio!.overallBalance = realizedGains
        }
        
        for index in 0..<portfolio!.holdings.count {
            if portfolio!.holdings[index].ticker == ticker {
                try! realm.write {
                    portfolio!.holdings[index].shares -= shares
                    portfolioCards[index].shares -= shares
                    if portfolio!.holdings[index].shares == 0 {
                        realm.delete(portfolio!.holdings[index])
                        for i in 0..<portfolioCards.count {
                            if portfolioCards[i].ticker == ticker {
                                // if applicable set the selected card to the next one
                                if i == 0 && portfolioCards.count > 1{
                                    portfolioCards[i+1].isSelected = true
                                } else if i > 0 && portfolioCards.count > 1 {
                                    portfolioCards[0].isSelected = true
                                }
                                portfolioCards.remove(at: i)
                                if portfolioCards.count == 0 {
                                    self.presentStocks = false;
                                }
                                break
                            }
                        }
                    }
                }
                self.unrealizedGains = calculateUnrealizedGains()
                return
            }
        }
    }
    
    func buyShare(ticker: String, shares: Int, salePrice: Double) {
        let realm = try! Realm()
        // Update balance to the new balance
        self.totalStockValue += (salePrice * Double(shares))
        
        // iterate thru cards to see if ticker already in portfolio
        for index in 0..<portfolio!.holdings.count {
            if portfolio!.holdings[index].ticker == ticker {
                try! realm.write {
                    portfolio!.holdings[index].avgCost = ( (portfolioCards[index].equity) + (salePrice * Double(shares)) ) / Double((portfolioCards[index].shares + shares))
                    portfolio!.holdings[index].shares = portfolioCards[index].shares + shares
                }
                portfolioCards[index].avgCost = ( (portfolioCards[index].equity) + (salePrice * Double(shares)) ) / Double((portfolioCards[index].shares + shares))
                portfolioCards[index].shares = portfolioCards[index].shares + shares
                self.unrealizedGains = calculateUnrealizedGains()
                return
            }
        }
        
        // If here, write new stock
        let stockHolding = RealmStockData()
        stockHolding.ticker = ticker
        stockHolding.avgCost = salePrice
        stockHolding.shares = shares
        try! realm.write {
            portfolio!.holdings.append(stockHolding)
            self.appendStockData(holding: stockHolding)
        }
        self.unrealizedGains = calculateUnrealizedGains()
    }
    
    private var emptyStock: Stock {
        Stock(companyName: "", ticker: "", avgCost: 0.0, shares: 0, currentPrice: 0.0, percentChange: 0.0, dailyChange: 0.0, volume: 0, avgVolume: 0, imageName: "")
    }
}
