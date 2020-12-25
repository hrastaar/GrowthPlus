//
//  SearchQuery.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/14/20.
//

import Alamofire
import SwiftyJSON

final class SearchQuery: ObservableObject {
    @Published var searchResults = [SearchResult]()
    @Published var stockNewsArticles = [StockNewsArticle]()
    @Published var stockPageData = StockPageData()
    @Published var stockChartPoints = [StockChartPoint]()
    static let shared = SearchQuery()

    // Gather List of Search Results for Ticker
    func searchTicker(ticker: String, exchange _: String?) {
        var validTickerResultCount: Int = 0
        let stockTickerSearchURL = URL(string: "https://cloud.iexapis.com/stable/search/\(ticker)?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let stockTickerSearchRequest: DataRequest = AF.request(stockTickerSearchURL)
        stockTickerSearchRequest.responseJSON { data in
            do {
                if let responseData = data.data {
                    // clear old search results
                    self.searchResults = []
                    let json: JSON = try JSON(data: responseData)
                    let searchResultsArray: [JSON] = json.arrayValue

                    // append new search results
                    for stock in searchResultsArray {
                        if stock["region"].stringValue == "US" {
                            let searchRes = SearchResult(ticker: stock["symbol"].stringValue, companyName: stock["securityName"].stringValue)
                            self.searchResults.append(searchRes)
                            validTickerResultCount += 1
                        }
                        if validTickerResultCount >= 10 {
                            return
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
        fetchNewsArticles(ticker: ticker)
        var stock: StockPageData?
        // build get request
        let fetchStockDataURL = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let stockPageRequest: DataRequest = AF.request(fetchStockDataURL)
        stockPageRequest.responseJSON { data in
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
                    // distinct info for stock page
                    let open: Double = json["open"].doubleValue
                    let low: Double = json["low"].doubleValue
                    let high: Double = json["high"].doubleValue

                    let yearLow: Double = json["week52Low"].doubleValue
                    let yearHigh: Double = json["week52High"].doubleValue

                    let primaryExchange: String = json["primaryExchange"].stringValue
                    let marketCap: Int = json["marketCap"].intValue
                    let peRatio: Double = json["peRatio"].doubleValue

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

    func fetchNewsArticles(ticker: String) {
        stockNewsArticles.removeAll()
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/news?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let articleAPIRequest: DataRequest = AF.request(url)
        articleAPIRequest.responseJSON { data in
            do {
                if let articleData = data.data {
                    let json: JSON = try JSON(data: articleData)
                    let articleArray = json.arrayValue
                    for article in articleArray {
                        let articleLanguage: String? = article["lang"].stringValue
                        if articleLanguage != nil, articleLanguage == "en" {
                            let date: Int = article["datetime"].intValue
                            let headline: String = article["headline"].stringValue
                            let source: String = article["source"].stringValue

                            let articleURLString: String = article["url"].stringValue
                            let articleURL = URL(string: articleURLString)!

                            let relatedString: String = article["related"].stringValue
                            let relatedTickersArray: [String] = relatedString.components(separatedBy: ",")
                            let imageURLString: String = article["image"].stringValue
                            let imageURL = URL(string: imageURLString)!

                            let newsArticle = StockNewsArticle(date: date, ticker: ticker, headline: headline, source: source, articleURL: articleURL, related: relatedTickersArray, imageURL: imageURL)
                            print(newsArticle)
                            self.stockNewsArticles.append(newsArticle)
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func gatherChartPoints(ticker: String) {
        stockChartPoints.removeAll()
        let url = URL(string: "https://cloud.iexapis.com/stable//stock/\(ticker)/intraday-prices?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let chartDataRequest: DataRequest = AF.request(url)
        chartDataRequest.responseJSON { data in
            do {
                if let chartData = data.data {
                    let json: JSON = try JSON(data: chartData)
                    let chartDataArray = json.arrayValue
                    for point in chartDataArray {
                        let timeStr: String = point["label"].stringValue
                        let avgPrice: Double = point["average"].doubleValue
                        let highPrice: Double = point["high"].doubleValue
                        let lowPrice: Double = point["low"].doubleValue
                        if highPrice == Double(0) || lowPrice == Double(0) || avgPrice == Double(0) {
                            continue
                        }
                        let stockChartPoint = StockChartPoint(timeLabel: timeStr, avgPrice: avgPrice, highPrice: highPrice, lowPrice: lowPrice)
                        print(stockChartPoint)
                        self.stockChartPoints.append(stockChartPoint)
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

// Info stored for news section of stock view page
struct StockNewsArticle {
    let date: Int
    let ticker: String
    let headline: String
    let source: String
    let articleURL: URL
    let related: [String]
    let imageURL: URL
}

struct StockChartPoint {
    let timeLabel: String
    let avgPrice: Double
    let highPrice: Double
    let lowPrice: Double
}
