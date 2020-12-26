//
//  SearchQuery.swift
//  GrowthPlus
//
//  Created by Rastaar Haghi on 12/14/20.
//

import Alamofire
import SwiftyJSON

final class FinancialAPIConnection: ObservableObject {
    @Published var searchResults = [SearchResult]()
    @Published var stockNewsArticles = [StockNewsArticle]()
    @Published var stockPageData = StockPageData()
    @Published var stockChartPoints = [StockChartPoint]()
    @Published var stockEarnings = [Earnings]()
    
    static let shared = FinancialAPIConnection()

    // Gather List of Search Results for Ticker
    public func searchTicker(ticker: String, exchange _: String?) {
        self.searchResults.removeAll()
        let stockTickerSearchURL = URL(string: "https://cloud.iexapis.com/stable/search/\(ticker)?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let stockTickerSearchRequest: DataRequest = AF.request(stockTickerSearchURL)
        stockTickerSearchRequest.responseJSON { data in
            do {
                if let responseData = data.data {
                    var searchResults: [SearchResult] = try JSONDecoder().decode([SearchResult].self, from: responseData)
                    searchResults.removeAll(where: { $0.region != "US" })
                    self.searchResults = Array(searchResults.prefix(10))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchStockPageData(ticker: String, numEarningsReports: Int? = 4) {
        self.fetchStockData(ticker: ticker)
        self.fetchNewsArticles(ticker: ticker)
        self.gatherChartPoints(ticker: ticker)
        self.fetchEarningsReports(ticker: ticker, numberOfReports: numEarningsReports)
    }

    // PRIVATE FINANCIAL TOOL FUNCTIONALITIES
    
    // Gather Stock Data for Ticker
    private func fetchStockData(ticker: String) {
        // build get request
        let fetchStockDataURL = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/quote?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let stockPageRequest: DataRequest = AF.request(fetchStockDataURL)
        stockPageRequest.responseJSON { data in
            do {
                if let currData = data.data {
                    let stockPageData = try JSONDecoder().decode(StockPageData.self, from: currData)
                    self.stockPageData = stockPageData
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func fetchNewsArticles(ticker: String) {
        stockNewsArticles.removeAll()
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/\(ticker)/news?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let articleAPIRequest: DataRequest = AF.request(url)
        articleAPIRequest.responseJSON { data in
            do {
                if let articleData = data.data {
                    var articleObjectArray: [StockNewsArticle] = try JSONDecoder().decode([StockNewsArticle].self, from: articleData)
                    articleObjectArray.removeAll(where: {$0.language != "en"})
                    self.stockNewsArticles = articleObjectArray
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func gatherChartPoints(ticker: String) {
        stockChartPoints.removeAll()
        let url = URL(string: "https://cloud.iexapis.com/stable//stock/\(ticker)/intraday-prices?token=pk_c154ec9b3d75402bb77e126b940ed4ca")!
        let chartDataRequest: DataRequest = AF.request(url)
        chartDataRequest.responseJSON { data in
            do {
                if let chartData = data.data {
                    var chartDataPoints: [StockChartPoint] = try JSONDecoder().decode([StockChartPoint].self, from: chartData)
                    chartDataPoints.removeAll(where: { $0.avgPrice == 0.00 || $0.highPrice == 0.00 || $0.lowPrice == 0.00 })
                    self.stockChartPoints = chartDataPoints
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchEarningsReports(ticker: String, numberOfReports: Int? = 4) {
        stockEarnings.removeAll()
        let earningsURLString: String = "https://cloud.iexapis.com/stable/stock/\(ticker)/earnings/\(numberOfReports!)?token=pk_c154ec9b3d75402bb77e126b940ed4ca"
        let url = URL(string: earningsURLString)!
        let earningsDataRequest: DataRequest = AF.request(url)
        earningsDataRequest.responseJSON { data in
            do {
                if let earningsData = data.data {
                    let responseJSON: JSON = try JSON(data: earningsData)
                    let earningsData = try responseJSON["earnings"].rawData()
                    let earningsObjectArray: [Earnings] = try JSONDecoder().decode([Earnings].self, from: earningsData)
                    print(earningsObjectArray)
                    self.stockEarnings = earningsObjectArray
                    return
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
