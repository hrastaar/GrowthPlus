//
//  SearchQuery.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/14/20.
//

import Alamofire
import SwiftyJSON

final class SearchQuery: ObservableObject {
    @Published var searchResults: [SearchResult] = []
    @Published var stockPageData: StockPageData = StockPageData()
    static let shared = SearchQuery()
    
    // Gather List of Search Results for Ticker
    func searchTicker(ticker: String, exchange: String?) {
        var i = 0
        var url: URL
        if let inputExchange = exchange {
            url = URL(string: "https://dumbstockapi.com/stock?ticker_search=\(ticker)&exchange=\(inputExchange)")!
        } else {
            url = URL(string: "https://dumbstockapi.com/stock?ticker_search=\(ticker)&exchange=NASDAQ")!
        }
        
        print("CALL...")
        let request = AF.request(url)
        request.responseJSON { data in
            do {
                if let currData = data.data {
                    // clear old search results
                    print("...RESULT")
                    self.searchResults = []
                    let json = try JSON(data: currData)
                    let searchResult = json.arrayValue

                    // append new search results
                    for stock in searchResult {
                        let searchRes: SearchResult = SearchResult(ticker: stock["ticker"].stringValue, companyName: stock["name"].stringValue)
                        self.searchResults.append(searchRes)
                        i += 1
                        if(i == 5) {
                            if exchange == nil {
                                self.searchTicker(ticker: ticker, exchange: "NYSE")
                            }
                            break
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    // Gather Stock Data for Ticker
    func fetchStockData(ticker: String) {
        var stock: StockPageData?
        // build get request
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
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
                    // distinct info for stock page
                    let open = json["open"].doubleValue
                    let low = json["low"].doubleValue
                    let high = json["high"].doubleValue
                    
                    let yearLow = json["week52Low"].doubleValue
                    let yearHigh = json["week52High"].doubleValue
                    
                    let primaryExchange = json["primaryExchange"].stringValue
                    let marketCap = json["marketCap"].intValue
                    let peRatio = json["peRatio"].doubleValue
                    stock = StockPageData(companyName: companyName, ticker: ticker, currentPrice: currPrice, percentChange: percentChange, dailyChange: dailyChange, volume: volume, avgVolume: avgVolume, open: open, low: low, high: high, yearLow: yearLow, yearHigh: yearHigh, primaryExchange: primaryExchange, marketCap: marketCap, peRatio: peRatio)
                    if let validStock = stock {
                        self.stockPageData = validStock
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
}

// Data for each search result cell
struct SearchResult {
    let ticker: String
    let companyName: String
}
